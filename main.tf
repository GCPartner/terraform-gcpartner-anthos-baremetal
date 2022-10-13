resource "random_string" "cluster_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "tls_private_key" "ssh_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  cluster_name  = format("%s-%s", var.cluster_name, random_string.cluster_suffix.result)
  ssh_key_name  = format("anthos-%s-%s", var.cluster_name, random_string.cluster_suffix.result)
  cp_node_count = var.ha_control_plane ? 3 : 1
  ssh_key = {
    private_key = chomp(tls_private_key.ssh_key_pair.private_key_pem)
    public_key  = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
  }
}

resource "local_file" "cluster_private_key_pem" {
  content         = local.ssh_key.private_key
  filename        = pathexpand(format("~/.ssh/%s", local.ssh_key_name))
  file_permission = "0600"
}

terraform {
  required_providers {
    equinix = {
      source = "equinix/equinix"
    }
    pnap = {
      source = "phoenixnap/pnap"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
}

provider "equinix" {
  auth_token = var.metal_auth_token
}

provider "pnap" {
  client_id     = var.pnap_client_id
  client_secret = var.pnap_client_secret
}

module "GCP_Auth" {
  source         = "./modules/google-cloud-platform"
  cluster_name   = local.cluster_name
  gcp_project_id = var.gcp_project_id
}

module "GCP_Infra" {
  source                   = "./modules/google-compute-engine"
  count                    = var.cloud == "GCP" ? 1 : 0
  operating_system         = var.operating_system
  create_project           = var.create_project
  project_name             = var.project_name
  project_id               = var.gcp_project_id
  organization_id          = var.organization_id
  ssh_key                  = local.ssh_key
  cp_node_count            = local.cp_node_count
  worker_node_count        = var.worker_node_count
  cluster_name             = local.cluster_name
  gcp_cp_instance_type     = var.gcp_cp_instance_type
  gcp_worker_instance_type = var.gcp_worker_instance_type
  gcp_zone                 = var.gcp_zone
  gcp_billing_account      = var.gcp_billing_account
  private_subnet           = var.private_subnet
}

module "PNAP_Infra" {
  source             = "./modules/phoenixnap"
  count              = var.cloud == "PNAP" ? 1 : 0
  ssh_key            = local.ssh_key
  cp_node_count      = local.cp_node_count
  worker_node_count  = var.worker_node_count
  cluster_name       = local.cluster_name
  operating_system   = var.operating_system
  pnap_location      = var.pnap_location
  pnap_cp_type       = var.pnap_cp_type
  pnap_worker_type   = var.pnap_worker_type
  public_network_id  = var.public_network_id
  private_network_id = var.private_network_id
  private_subnet     = var.private_subnet
  create_network     = var.create_network
  network_type       = var.network_type
}

module "EQM_Infra" {
  source                = "./modules/equinix-metal"
  count                 = var.cloud == "EQM" ? 1 : 0
  metal_auth_token      = var.metal_auth_token
  metal_organization_id = var.organization_id
  create_project        = var.create_project
  project_name          = var.project_name
  project_id            = var.metal_project_id
  metal_cp_plan         = var.metal_cp_plan
  metal_worker_plan     = var.metal_worker_plan
  cp_node_count         = local.cp_node_count
  worker_node_count     = var.worker_node_count
  metal_facility        = var.metal_facility
  operating_system      = var.operating_system
  metal_billing_cycle   = var.metal_billing_cycle
  cluster_name          = local.cluster_name
  private_subnet        = var.private_subnet
  ssh_key               = local.ssh_key
}

locals {
  eqm_ip           = var.cloud == "EQM" ? module.EQM_Infra.0.bastion_ip : ""
  eqm_user         = var.cloud == "EQM" ? module.EQM_Infra.0.username : ""
  eqm_cp_ips       = var.cloud == "EQM" ? module.EQM_Infra.0.cp_node_ips : []
  eqm_worker_ips   = var.cloud == "EQM" ? module.EQM_Infra.0.worker_node_ips : []
  eqm_priv_net_id  = var.cloud == "EQM" ? "not_implemented" : ""
  eqm_priv_vlan_id = var.cloud == "EQM" ? module.EQM_Infra.0.vlan_id : ""
  eqm_priv_cidr    = var.cloud == "EQM" ? module.EQM_Infra.0.subnet : ""
  eqm_pub_net_id   = var.cloud == "EQM" ? "not_implemented" : ""
  eqm_pub_vlan_id  = var.cloud == "EQM" ? module.EQM_Infra.0.vlan_id : ""
  eqm_pub_cidr     = var.cloud == "EQM" ? module.EQM_Infra.0.subnet : ""
  eqm_os_image     = var.cloud == "EQM" ? module.EQM_Infra.0.os_image : ""

  gcp_ip           = var.cloud == "GCP" ? module.GCP_Infra.0.bastion_ip : ""
  gcp_user         = var.cloud == "GCP" ? module.GCP_Infra.0.username : ""
  gcp_cp_ips       = var.cloud == "GCP" ? module.GCP_Infra.0.cp_node_ips : []
  gcp_worker_ips   = var.cloud == "GCP" ? module.GCP_Infra.0.worker_node_ips : []
  gcp_priv_net_id  = var.cloud == "GCP" ? "not_implemented" : ""
  gcp_priv_vlan_id = var.cloud == "GCP" ? module.GCP_Infra.0.vlan_id : ""
  gcp_priv_cidr    = var.cloud == "GCP" ? module.GCP_Infra.0.subnet : ""
  gcp_pub_net_id   = var.cloud == "GCP" ? "not_implemented" : ""
  gcp_pub_vlan_id  = var.cloud == "GCP" ? module.GCP_Infra.0.vlan_id : ""
  gcp_pub_cidr     = var.cloud == "GCP" ? module.GCP_Infra.0.subnet : ""
  gcp_os_image     = var.cloud == "GCP" ? module.GCP_Infra.0.os_image : ""

  pnap_ip           = var.cloud == "PNAP" ? module.PNAP_Infra.0.bastion_ip : ""
  pnap_user         = var.cloud == "PNAP" ? module.PNAP_Infra.0.username : ""
  pnap_cp_ips       = var.cloud == "PNAP" ? module.PNAP_Infra.0.cp_node_ips : []
  pnap_worker_ips   = var.cloud == "PNAP" ? module.PNAP_Infra.0.worker_node_ips : []
  pnap_priv_net_id  = var.cloud == "PNAP" ? module.PNAP_Infra.0.network_details["private_network"].id : ""
  pnap_priv_vlan_id = var.cloud == "PNAP" ? module.PNAP_Infra.0.network_details["private_network"].vlan_id : ""
  pnap_priv_cidr    = var.cloud == "PNAP" ? module.PNAP_Infra.0.network_details["private_network"].cidr : ""
  pnap_pub_net_id   = var.cloud == "PNAP" ? module.PNAP_Infra.0.network_details["public_network"].id : ""
  pnap_pub_vlan_id  = var.cloud == "PNAP" ? module.PNAP_Infra.0.network_details["public_network"].vlan_id : ""
  pnap_pub_cidr     = var.cloud == "PNAP" ? module.PNAP_Infra.0.network_details["public_network"].cidr : ""
  pnap_os_image     = var.cloud == "PNAP" ? module.PNAP_Infra.0.os_image : ""

  bastion_ip   = coalesce(local.eqm_ip, local.gcp_ip, local.pnap_ip)
  username     = coalesce(local.eqm_user, local.gcp_user, local.pnap_user)
  cp_ips       = coalescelist(local.eqm_cp_ips, local.gcp_cp_ips, local.pnap_cp_ips)
  worker_ips   = var.worker_node_count > 0 ? coalescelist(local.eqm_worker_ips, local.gcp_worker_ips, local.pnap_worker_ips) : []
  priv_net_id  = coalesce(local.eqm_priv_net_id, local.gcp_priv_net_id, local.pnap_priv_net_id)
  priv_vlan_id = coalesce(local.eqm_priv_vlan_id, local.gcp_priv_vlan_id, local.pnap_priv_vlan_id)
  priv_cidr    = coalesce(local.eqm_priv_cidr, local.gcp_priv_cidr, local.pnap_priv_cidr)
  pub_net_id   = coalesce(local.eqm_pub_net_id, local.gcp_pub_net_id, local.pnap_pub_net_id)
  pub_vlan_id  = coalesce(local.eqm_pub_vlan_id, local.gcp_pub_vlan_id, local.pnap_pub_vlan_id)
  pub_cidr     = coalesce(local.eqm_pub_cidr, local.gcp_pub_cidr, local.pnap_pub_cidr)
  os_image     = coalesce(local.eqm_os_image, local.gcp_os_image, local.pnap_os_image)
}

module "Ansible_Bootstrap" {
  depends_on = [
    module.GCP_Auth,
    module.EQM_Infra,
    module.GCP_Infra,
    module.PNAP_Infra
  ]
  source                   = "./modules/ansible-bootstrap"
  ssh_key                  = local.ssh_key
  cp_node_count            = local.cp_node_count
  worker_node_count        = var.worker_node_count
  bastion_ip               = local.bastion_ip
  cp_ips                   = local.cp_ips
  worker_ips               = local.worker_ips
  server_subnet            = var.network_type == "private" ? local.priv_cidr : local.pub_cidr
  cluster_name             = local.cluster_name
  operating_system         = var.operating_system
  username                 = local.username
  ansible_playbook_version = var.ansible_playbook_version
  gcp_sa_keys              = module.GCP_Auth.gcp_sa_keys
  gcp_project_id           = var.gcp_project_id
  ansible_tar_ball         = var.ansible_tar_ball
  ansible_url              = var.ansible_url
}

locals {
  ssh_command            = "ssh -i ${pathexpand(format("~/.ssh/%s", local.ssh_key_name))} ${local.username}@${local.bastion_ip}"
  remote_kubeconfig_path = "$HOME/bootstrap/bmctl-workspace/${local.cluster_name}/${local.cluster_name}-kubeconfig"
}

data "external" "kubeconfig" {
  program = [
    "sh",
    "-c",
    "jq -n --arg content \"$(${local.ssh_command} cat ${local.remote_kubeconfig_path})\" '{$content}'",
  ]
}
