resource "random_string" "cluster_suffix" {
  length  = 5
  special = false
  upper   = false
}

locals {
  cluster_name  = format("%s-%s", var.cluster_name, random_string.cluster_suffix.result)
  ssh_key_name  = format("anthos-%s-%s", var.cluster_name, random_string.cluster_suffix.result)
  cp_node_count = var.ha_control_plane ? 3 : 1
}

resource "tls_private_key" "ssh_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "cluster_private_key_pem" {
  content         = chomp(tls_private_key.ssh_key_pair.private_key_pem)
  filename        = pathexpand(format("~/.ssh/%s", local.ssh_key_name))
  file_permission = "0600"
}

terraform {
  required_providers {
    metal = {
      source = "equinix/metal"
    }
    pnap = {
      source = "phoenixnap/pnap"
    }
  }
}

provider "metal" {
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

/* module "EQM_Infra" {
  source                = "./modules/equinix-metal"
  count                 = var.cloud == "EQM" ? 1 : 0
  metal_auth_token      = var.metal_auth_token
  metal_organization_id = var.organization_id
  create_project        = var.create_project
  project_name          = var.project_name
  project_id            = var.project_id
  cp_node_count         = local.cp_node_count
  worker_node_count     = var.worker_node_count
  metal_cp_plan         = var.metal_cp_plan
  metal_worker_plan     = var.metal_worker_plan
  metal_facility        = var.metal_facility
  operating_system      = var.operating_system
  metal_billing_cycle   = var.metal_billing_cycle
  cluster_name          = local.cluster_name
  private_subnet        = var.private_subnet
  ssh_key = {
    private_key = chomp(tls_private_key.ssh_key_pair.private_key_pem)
    public_key  = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
  }
} */

/* module "GCP_Infra" {
  source           = "./modules/google-compute-engine"
  count            = var.cloud == "GCP" ? 1 : 0
  operating_system = var.operating_system
  create_project   = var.create_project
  project_name     = var.project_name
  project_id       = var.project_id
  organization_id  = var.organization_id
  ssh_key = {
    private_key = chomp(tls_private_key.ssh_key_pair.private_key_pem)
    public_key  = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
  }
  cp_node_count            = local.cp_node_count
  worker_node_count        = var.worker_node_count
  cluster_name             = local.cluster_name
  gcp_cp_instance_type     = var.gcp_cp_instance_type
  gcp_worker_instance_type = var.gcp_worker_instance_type
  gcp_zone                 = var.gcp_zone
  gcp_billing_account      = var.gcp_billing_account
  private_subnet           = var.private_subnet
} */

module "PNAP_Infra" {
  source = "./modules/phoenixnap"
  count  = var.cloud == "PNAP" ? 1 : 0
  ssh_key = {
    private_key = chomp(tls_private_key.ssh_key_pair.private_key_pem)
    public_key  = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
  }
  cp_node_count     = local.cp_node_count
  worker_node_count = var.worker_node_count
  cluster_name      = local.cluster_name
  operating_system  = var.operating_system
  pnap_location     = var.pnap_location
  pnap_cp_type      = var.pnap_cp_type
  pnap_worker_type  = var.pnap_worker_type
  private_subnet    = var.private_subnet
}

locals {
  /* eqm_ip     = var.cloud == "EQM" ? module.EQM_Infra.0.bastion_ip : ""
  gcp_ip     = var.cloud == "GCP" ? module.GCP_Infra.0.bastion_ip : ""
  pnap_ip    = var.cloud == "PNAP" ? module.PNAP_Infra.0.bastion_ip : ""
  eqm_user   = var.cloud == "EQM" ? module.EQM_Infra.0.bastion_ip : ""
  gcp_user   = var.cloud == "GCP" ? module.GCP_Infra.0.username : ""
  pnap_user  = var.cloud == "PNAP" ? module.PNAP_Infra.0.username : "" */
  eqm_ip          = ""
  gcp_ip          = ""
  pnap_ip         = var.cloud == "PNAP" ? module.PNAP_Infra.0.bastion_ip : ""
  eqm_user        = ""
  gcp_user        = ""
  eqm_cp_ips      = []
  gcp_cp_ips      = []
  pnap_cp_ips     = module.PNAP_Infra.0.cp_node_ips
  eqm_worker_ips  = []
  gcp_worker_ips  = []
  pnap_worker_ips = module.PNAP_Infra.0.worker_node_ips
  pnap_user       = var.cloud == "PNAP" ? module.PNAP_Infra.0.username : ""
  bastion_ip      = coalesce(local.eqm_ip, local.gcp_ip, local.pnap_ip)
  username        = coalesce(local.eqm_user, local.gcp_user, local.pnap_user)
  cp_ips          = coalescelist(local.eqm_cp_ips, local.gcp_cp_ips, local.pnap_cp_ips)
  worker_ips      = coalescelist(local.eqm_worker_ips, local.gcp_worker_ips, local.pnap_worker_ips)
}

/* module "Anthos_Private_Mode" {
  depends_on = [
    module.EQM_Infra,
    module.GCP_Infra,
    module.PNAP_Infra
  ]
  source = "./modules/anthos-private-mode"
  ssh_key = {
    private_key = chomp(tls_private_key.ssh_key_pair.private_key_pem)
    public_key  = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
  }
  bastion_ip          = local.bastion_ip
  node_count          = var.node_count
  operating_system    = var.operating_system
  private_subnet      = var.private_subnet
  cluster_name        = local.cluster_name
  apm_version         = var.apm_version
  deploy_user_cluster = var.deploy_user_cluster
  username            = local.username
  deploy_csi          = var.deploy_csi
} */

module "Ansible_Bootstrap" {
  depends_on = [
    #module.EQM_Infra,
    #module.GCP_Infra,
    module.PNAP_Infra
  ]
  source = "./modules/ansible-bootstrap"
  ssh_key = {
    private_key = chomp(tls_private_key.ssh_key_pair.private_key_pem)
    public_key  = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
  }
  cp_node_count            = local.cp_node_count
  worker_node_count        = var.worker_node_count
  bastion_ip               = local.bastion_ip
  cp_ips                   = local.cp_ips
  worker_ips               = local.worker_ips
  private_subnet           = var.private_subnet
  cluster_name             = local.cluster_name
  abm_version              = var.abm_version
  operating_system         = var.operating_system
  username                 = local.username
  ansible_playbook_version = var.ansible_playbook_version
  gcp_sa_keys = module.GCP_Auth.gcp_sa_keys
  gcp_project_id = var.gcp_project_id
}
