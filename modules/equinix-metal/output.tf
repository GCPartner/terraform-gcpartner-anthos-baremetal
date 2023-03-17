output "bastion_ip" {
  value       = equinix_metal_device.cp_node.0.access_public_ipv4
  description = "Bastion Host IP"
}

output "username" {
  value = local.username
}

output "cp_node_ips" {
  value       = [equinix_metal_device.cp_node.*.access_private_ipv4][0]
  description = "First IP of control plane nodes"
}

output "cp_node_ids" {
  value       = equinix_metal_device.cp_node.*.id
  description = "ID of control plane nodes"
}

output "worker_node_ips" {
  value       = [equinix_metal_device.worker_node.*.access_private_ipv4][0]
  description = "First IP of worker nodes"
}

output "worker_node_ids" {
  value       = equinix_metal_device.worker_node.*.id
  description = "ID of worker nodes"
}

output "vlan_id" {
  value       = 1234
  description = "The vLan ID used for the private network"
}

output "subnet" {
  value       = var.private_subnet
  description = "The private IP space for the cluster"
}

output "os_image" {
  value       = var.operating_system
  description = "The OS Image used to build the nodes"
}

output "cp_vip" {
  value       = equinix_metal_reserved_ip_block.cp_vip.network
  description = "The CP VIP"
}

output "ingress_vip" {
  value       = equinix_metal_reserved_ip_block.ingress_vip.network
  description = "The Ingress VIP"
}