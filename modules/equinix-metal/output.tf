output "bastion_ip" {
  value       = equinix_metal_device.cp_node.0.access_public_ipv4
  description = "Bastion Host IP"
}

output "username" {
  value = local.username
}

output "cp_node_ips" {
  value       = [equinix_metal_device.cp_node.*.access_public_ipv4][0]
  description = "First IP of control plane nodes"
}

output "cp_node_ids" {
  value       = equinix_metal_device.cp_node.*.id
  description = "ID of control plane nodes"
}

output "worker_node_ips" {
  value       = [equinix_metal_device.worker_node.*.access_public_ipv4][0]
  description = "First IP of worker nodes"
}

output "worker_node_ids" {
  value       = equinix_metal_device.worker_node.*.id
  description = "ID of worker nodes"
}


output "os_image" {
  value       = var.operating_system
  description = "The OS Image used to build the nodes"
}

output "lb_vip_subnet" {
  value       = "${equinix_metal_reserved_ip_block.lb_vip_subnet.network}/${equinix_metal_reserved_ip_block.lb_vip_subnet.cidr}"
  description = "The load balancer VIP network subnet"
}

output "lb_vip_id" {
  value       = equinix_metal_reserved_ip_block.lb_vip_subnet.id
  description = "The load balancer VIP network id"
}
