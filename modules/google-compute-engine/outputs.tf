output "bastion_ip" {
  value = google_compute_address.bastion_ip.address
}

output "username" {
  value = local.username
}

output "name" {
  value = google_compute_instance.cp_node.*.network_interface.0.network_ip
}

output "worker_node_ips" {
  value       = google_compute_instance.worker_node.*.network_interface.0.network_ip
  description = "First IP of worker nodes"
}

output "cp_node_ips" {
  value       = google_compute_instance.cp_node.*.network_interface.0.network_ip
  description = "First IP of cp nodes"
}

output "vlan_id" {
  value       = "Not applicable for Google cloud"
  description = "Not applicable for Google cloud"
}

output "subnet" {
  value       = var.private_subnet
  description = "The private IP space for the cluster"
}

output "os_image" {
  value       = local.os_image
  description = "The OS Image used to build the nodes"
}
