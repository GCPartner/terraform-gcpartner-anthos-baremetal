terraform {
  required_providers {
    pnap = {
      source = "phoenixnap/pnap"
    }
  }
}

locals {
  os_image    = var.operating_system == "ubuntu_20_04" ? "ubuntu/focal" : ""
  username    = "ubuntu"
  pnap_subnet = "10.11.12.0/24"
}

resource "pnap_private_network" "new_network" {
  name     = format("pnet-%s", var.cluster_name)
  cidr     = local.pnap_subnet
  location = var.pnap_location
}

resource "pnap_server" "cp_node" {
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
          id = pnap_private_network.new_network.id
        }
      }
    }
  }
}

resource "pnap_server" "worker_node" {
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
          id = pnap_private_network.new_network.id
        }
      }
    }
  }
}

data "template_file" "node_networking_cp" {
  count    = var.cp_node_count
  template = file("${path.module}/templates/node_networking.py")
  vars = {
    ip_cidr = format("%s/%s", cidrhost(var.private_subnet, count.index + 1), split("/", var.private_subnet).1)
    vlan_id = pnap_private_network.new_network.vlan_id
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
    destination = "$HOME/bootstrap/node_networking.py"
  }

  provisioner "remote-exec" {
    inline = ["sudo python3 $HOME/bootstrap/node_networking.py"]
  }
}

data "template_file" "node_networking_worker" {
  count    = var.worker_node_count
  template = file("${path.module}/templates/node_networking.py")
  vars = {
    ip_cidr = format("%s/%s", cidrhost(var.private_subnet, count.index + 4), split("/", var.private_subnet).1)
    vlan_id = pnap_private_network.new_network.vlan_id
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
    destination = "$HOME/bootstrap/node_networking.py"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo python3 $HOME/bootstrap/node_networking.py",
      "rm -f $HOME/bootstrap/node_networking.py"
    ]
  }
}
