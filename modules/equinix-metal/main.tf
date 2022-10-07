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
}

locals {
  metal_project_id = var.create_project ? equinix_metal_project.new_project[0].id : var.project_id
  username         = "root"
}

resource "equinix_metal_project_ssh_key" "ssh_pub_key" {
  name       = var.cluster_name
  public_key = var.ssh_key.public_key
  project_id       = local.metal_project_id
}

resource "equinix_metal_device" "cp_node" {
  depends_on = [
    equinix_metal_project_ssh_key.ssh_pub_key
  ]
  count            = var.cp_node_count
  hostname         = format("%s-cp-%02d", var.cluster_name, count.index + 1)
  plan             = var.metal_worker_plan
  facilities       = [var.metal_facility]
  operating_system = var.operating_system
  billing_cycle    = var.metal_billing_cycle
  project_id       = local.metal_project_id
  tags             = ["anthos", "private"]
}

resource "equinix_metal_device" "worker_node" {
  depends_on = [
    equinix_metal_project_ssh_key.ssh_pub_key
  ]
  count            = var.worker_node_count
  hostname         = format("%s-worker-%02d", var.cluster_name, count.index + 1)
  plan             = var.metal_worker_plan
  facilities       = [var.metal_facility]
  operating_system = var.operating_system
  billing_cycle    = var.metal_billing_cycle
  project_id       = local.metal_project_id
  tags             = ["anthos", "private"]
}

# for cp and worker
resource "equinix_metal_device_network_type" "convert_network_cp_node" {
  count     = var.cp_node_count
  device_id = equinix_metal_device.cp_node[count.index].id
  type      = "hybrid"
}

resource "equinix_metal_device_network_type" "convert_network_worker_node" {
  count     = var.worker_node_count
  device_id = equinix_metal_device.worker_node[count.index].id
  type      = "hybrid"
}

resource "equinix_metal_vlan" "private_vlan" {
  facility   = var.metal_facility
  project_id = local.metal_project_id
}


# for cp and workers
resource "equinix_metal_port_vlan_attachment" "private_vlan_attach_cp_node" {
  count     = var.cp_node_count
  device_id = equinix_metal_device_network_type.convert_network_cp_node[count.index].id
  port_name = "eth1"
  vlan_vnid = equinix_metal_vlan.private_vlan.vxlan
}
resource "equinix_metal_port_vlan_attachment" "private_vlan_attach_worker_node" {
  count     = var.worker_node_count
  device_id = equinix_metal_device_network_type.convert_network_worker_node[count.index].id
  port_name = "eth1"
  vlan_vnid = equinix_metal_vlan.private_vlan.vxlan
}

data "template_file" "cp_node_networking" {
  count    = var.cp_node_count
  template = file("${path.module}/templates/node_networking.sh")
  vars = {
    operating_system = var.operating_system
    ip_address       = cidrhost(var.private_subnet, count.index + 2)
    netmask          = cidrnetmask(var.private_subnet)
  }
}

# cp node and worker node
resource "null_resource" "cp_node_networking" {
  count = var.cp_node_count
  connection {
    type        = "ssh"
    user        = local.username
    private_key = var.ssh_key.private_key
    host        = element(equinix_metal_device.cp_node.*.access_public_ipv4, count.index)
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p $HOME/bootstrap/"
    ]
  }

  provisioner "file" {
    content     = element(data.template_file.cp_node_networking.*.rendered, count.index)
    destination = "/${local.username}/bootstrap/node_networking.sh"
  }

  provisioner "remote-exec" {
    inline = ["bash $HOME/bootstrap/node_networking.sh"]
  }
}

data "template_file" "worker_node_networking" {
  count    = var.worker_node_count
  template = file("${path.module}/templates/node_networking.sh")
  vars = {
    operating_system = var.operating_system
    ip_address       = cidrhost(var.private_subnet, count.index + 5)
    netmask          = cidrnetmask(var.private_subnet)
  }
}


resource "null_resource" "worker_node_networking" {
  count = var.worker_node_count
  connection {
    type        = "ssh"
    user        = local.username
    private_key = var.ssh_key.private_key
    host        = element(equinix_metal_device.worker_node.*.access_public_ipv4, count.index)
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p $HOME/bootstrap/"
    ]
  }

  provisioner "file" {
    content     = element(data.template_file.worker_node_networking.*.rendered, count.index)
    destination = "/${local.username}/bootstrap/node_networking.sh"
  }

  provisioner "remote-exec" {
    inline = ["bash $HOME/bootstrap/node_networking.sh"]
  }
}
