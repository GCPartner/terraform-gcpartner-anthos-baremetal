terraform {
  required_providers {
    pnap = {
      source = "phoenixnap/pnap"
    }
  }
}

locals {
  os_image = var.operating_system == "ubuntu_20_04" ? "ubuntu/focal" : ""
  username = "ubuntu"
}

resource "pnap_ip_block" "new_ip_block" {
  count           = var.create_network ? 1 : 0
  location        = var.pnap_location
  cidr_block_size = "/28"
  description     = "IP block for public hosts and k8s services"
  lifecycle {
    ignore_changes = all
  }
}

resource "pnap_public_network" "new_network" {
  count       = var.create_network ? 1 : 0
  name        = format("%s-public-net", var.cluster_name)
  description = format("Public Network for:  %s", var.cluster_name)
  location    = var.pnap_location
  ip_blocks {
    public_network_ip_block {
      id = pnap_ip_block.new_ip_block[0].id
    }
  }
  lifecycle {
    ignore_changes = all
  }
}

data "pnap_public_network" "existing_network" {
  count = var.create_network ? 0 : 1
  id    = var.public_network_id
}

data "pnap_ip_block" "existing_ip_block" {
  count = var.create_network ? 0 : 1
  id    = data.pnap_public_network.existing_network[0].ip_blocks[0].id
}

resource "pnap_private_network" "new_network" {
  count    = var.create_network ? 1 : 0
  name     = format("%s-private-net", var.cluster_name)
  cidr     = var.private_subnet
  location = var.pnap_location
  lifecycle {
    ignore_changes = all
  }
}

data "pnap_private_network" "existing_network" {
  count = var.create_network ? 0 : 1
  id    = var.private_network_id
}

locals {
  pub_network  = var.create_network ? pnap_public_network.new_network[0] : data.pnap_public_network.existing_network[0]
  priv_network = var.create_network ? pnap_private_network.new_network[0] : data.pnap_private_network.existing_network[0]
  ip_block     = var.create_network ? pnap_ip_block.new_ip_block[0] : data.pnap_ip_block.existing_ip_block[0]
}

resource "pnap_server" "cp_node" {
  depends_on = [
    data.pnap_public_network.existing_network,
    pnap_public_network.new_network
  ]
  count    = var.cp_node_count
  hostname = format("%s-cp-%02d", var.cluster_name, count.index + 1)
  os       = local.os_image
  type     = var.pnap_cp_type
  location = var.pnap_location
  ssh_keys = [
    var.ssh_key.public_key
  ]
  network_configuration {
    private_network_configuration {
      configuration_type = "USER_DEFINED"
      private_networks {
        server_private_network {
          id  = local.priv_network.id
          ips = [cidrhost(local.priv_network.cidr, count.index + 2)]
        }
      }
    }
    ip_blocks_configuration {
      configuration_type = "NONE"
    }
    public_network_configuration {
      public_networks {
        server_public_network {
          id  = local.pub_network.id
          ips = [cidrhost(local.ip_block.cidr, count.index + 2)]
        }
      }
    }
    gateway_address = cidrhost(local.ip_block.cidr, 1)
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "pnap_server" "worker_node" {
  depends_on = [
    data.pnap_private_network.existing_network,
    pnap_private_network.new_network
  ]
  count    = var.worker_node_count
  hostname = format("%s-worker-%02d", var.cluster_name, count.index + 1)
  os       = local.os_image
  type     = var.pnap_worker_type
  location = var.pnap_location
  ssh_keys = [
    var.ssh_key.public_key
  ]
  network_configuration {
    private_network_configuration {
      configuration_type = "USER_DEFINED"
      private_networks {
        server_private_network {
          id  = local.priv_network.id
          ips = [cidrhost(local.priv_network.cidr, count.index + 5)]
        }
      }
    }
    ip_blocks_configuration {
      configuration_type = "NONE"
    }
    public_network_configuration {
      public_networks {
        server_public_network {
          id  = local.pub_network.id
          ips = [cidrhost(local.ip_block.cidr, count.index + 5)]
        }
      }
    }
    gateway_address = cidrhost(local.ip_block.cidr, 1)
  }
  lifecycle {
    ignore_changes = all
  }
}
