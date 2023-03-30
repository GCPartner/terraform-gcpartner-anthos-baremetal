terraform {
  required_providers {
    equinix = {
      source = "equinix/equinix"
    }
  }
}

resource "equinix_metal_project" "new_project" {
  count           = var.create_project ? 1 : 0
  name            = var.project_name
  organization_id = var.metal_organization_id
  bgp_config {
    deployment_type = "local"
    asn             = 65000
  }
}

locals {
  metal_project_id = var.create_project ? equinix_metal_project.new_project[0].id : var.project_id
  username         = "root"
}

resource "equinix_metal_project_ssh_key" "ssh_pub_key" {
  name       = var.cluster_name
  public_key = var.ssh_key.public_key
  project_id = local.metal_project_id
}

resource "equinix_metal_device" "cp_node" {
  depends_on = [
    equinix_metal_project_ssh_key.ssh_pub_key
  ]
  count            = var.cp_node_count
  hostname         = format("%s-cp-%02d", var.cluster_name, count.index + 1)
  plan             = var.metal_worker_plan
  metro            = var.metal_metro
  operating_system = var.operating_system
  billing_cycle    = var.metal_billing_cycle
  project_id       = local.metal_project_id
  tags             = ["anthos", "baremetal"]
  ip_address {
    type = "private_ipv4"
    cidr = 31
  }
  ip_address {
    type = "public_ipv4"
  }
}

resource "equinix_metal_device" "worker_node" {
  depends_on = [
    equinix_metal_project_ssh_key.ssh_pub_key
  ]
  count            = var.worker_node_count
  hostname         = format("%s-worker-%02d", var.cluster_name, count.index + 1)
  plan             = var.metal_worker_plan
  metro            = var.metal_metro
  operating_system = var.operating_system
  billing_cycle    = var.metal_billing_cycle
  project_id       = local.metal_project_id
  tags             = ["anthos", "baremetal"]
  ip_address {
    type = "private_ipv4"
    cidr = 29
  }
  ip_address {
    type = "public_ipv4"
  }
}

resource "equinix_metal_bgp_session" "enable_cp_bgp" {
  count          = var.cp_node_count
  device_id      = element(equinix_metal_device.cp_node.*.id, count.index)
  address_family = "ipv4"
}

resource "equinix_metal_bgp_session" "enable_worker_bgp" {
  count          = var.worker_node_count
  device_id      = element(equinix_metal_device.worker_node.*.id, count.index)
  address_family = "ipv4"
}

resource "equinix_metal_reserved_ip_block" "lb_vip_subnet" {
  project_id  = local.metal_project_id
  type        = "public_ipv4"
  metro       = var.metal_metro
  quantity    = var.metal_lb_vip_subnet_size
  description = "${var.cluster_name}: Load Balancer VIPs 01"
  tags        = ["cluster:${var.cluster_name}", "created_by:terraform", "created_at:${timestamp()}"]
}
