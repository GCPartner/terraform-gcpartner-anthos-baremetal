output "bastion_ip" {
  value       = metal_device.cp_node.0.access_public_ipv4
  description = "Bastion Host IP"
}

output "username" {
  value = local.username
}

output "cp_node_ips" {
  value       = [metal_device.cp_node.*.access_public_ipv4][0]
  description = "First IP of control plane nodes"
}

output "worker_node_ips" {
  value       = [metal_device.worker_node.*.access_public_ipv4][0]
  description = "First IP of worker nodes"
}

output "vlan_id" {
  value       = metal_vlan.private_vlan.vxlan
  description = "The vLan ID used for the private network"
}
