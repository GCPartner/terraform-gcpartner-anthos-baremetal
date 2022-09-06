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

/* 
data "template_file" "node_networking_cp" {
  depends_on = [
    data.pnap_private_network.existing_network,
    pnap_private_network.new_network
  ]
  count    = var.cp_node_count
  template = file("${path.module}/templates/node_networking.py")
  vars = {
    ip_cidr = format("%s/%s", cidrhost(var.private_subnet, count.index + 2), split("/", var.private_subnet).1)
    vlan_id = local.network.vlan_id
  }
}

resource "null_resource" "node_networking_cp" {
  count = var.cp_node_count
  connection {
    type        = "ssh"
    user        = local.username
    private_key = var.ssh_key.private_key
    host        = element(tolist(element(pnap_server.cp_node.*.public_ip_addresses, count.index)), 0)
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p $HOME/bootstrap/"
    ]
  }

  provisioner "file" {
    content     = element(data.template_file.node_networking_cp.*.rendered, count.index)
    destination = "/home/${local.username}/bootstrap/node_networking.py"
  }

  provisioner "remote-exec" {
    inline = ["sudo python3 $HOME/bootstrap/node_networking.py"]
  }
}

data "template_file" "node_networking_worker" {
  depends_on = [
    data.pnap_private_network.existing_network,
    pnap_private_network.new_network
  ]
  count    = var.worker_node_count
  template = file("${path.module}/templates/node_networking.py")
  vars = {
    ip_cidr = format("%s/%s", cidrhost(var.private_subnet, count.index + 5), split("/", var.private_subnet).1)
    vlan_id = local.network.vlan_id
  }
}

resource "null_resource" "node_networking_worker" {
  count = var.worker_node_count
  connection {
    type        = "ssh"
    user        = local.username
    private_key = var.ssh_key.private_key
    host        = element(tolist(element(pnap_server.worker_node.*.public_ip_addresses, count.index)), 0)
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p $HOME/bootstrap/"
    ]
  }

  provisioner "file" {
    content     = element(data.template_file.node_networking_worker.*.rendered, count.index)
    destination = "/home/${local.username}/bootstrap/node_networking.py"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo python3 $HOME/bootstrap/node_networking.py",
      "rm -f $HOME/bootstrap/node_networking.py"
    ]
  }
}
 */
