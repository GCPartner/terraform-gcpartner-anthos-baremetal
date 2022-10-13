output "bastion_ip" {
  value       = tolist(pnap_server.cp_node.0.public_ip_addresses).0
  description = "Bastion Host IP"
}

output "username" {
  value = local.username
}

output "cp_node_ips" {
  value       = [for cp_ip in pnap_server.cp_node.*.public_ip_addresses : element(tolist(cp_ip), 0)]
  description = "First IP of control plane nodes"
}

output "worker_node_ips" {
  value       = [for worker_ip in pnap_server.worker_node.*.public_ip_addresses : element(tolist(worker_ip), 0)]
  description = "First IP of worker nodes"
}

output "vlan_id" {
  value       = var.network_type == "private" ? local.priv_network.vlan_id : local.pub_network.vlan_id
  description = "The vLan ID used for the private network"
}

output "subnet" {
  value       = var.network_type == "private" ? local.priv_network.cidr : local.ip_block.cidr
  description = "Public Network CIDR"
}

output "network_details" {
  description = "The network details for the nodes"
  value = {
    primary_network = var.network_type == "private" ? "private_network" : "public_network"
    private_network = {
      id      = local.priv_network.id
      cidr    = local.priv_network.cidr
      vlan_id = local.priv_network.vlan_id
    }
    public_network = {
      id      = local.pub_network.id
      cidr    = local.ip_block.cidr
      vlan_id = local.pub_network.vlan_id
    }
  }
}

output "os_image" {
  value       = local.os_image
  description = "The OS Image used to build the nodes"
}
