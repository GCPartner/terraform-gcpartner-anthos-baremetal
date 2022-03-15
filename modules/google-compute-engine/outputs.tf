output "bastion_ip" {
  value = google_compute_address.bastion_ip.address
}

output "username" {
  value = local.username
}

output "name" {
  value = google_compute_instance.cp_node.*.network_interface.0.network_ip
}



# FIXME
#output "bastion_ip" {
#  value       = tolist(google_compute_instance.cp_node.0.public_ip_addresses).0
#  description = "Bastion Host IP"
#}

#output "cp_node_ips" {
#  value       = [for cp_ip in pnap_server.cp_node.*.public_ip_addresses : element(tolist(cp_ip), 0)]
#  description = "First IP of control plane nodes"
#}
#
output "worker_node_ips" {
  value   = google_compute_instance.worker_node.*.network_interface.0.network_ip
  description = "First IP of worker nodes"
}

output "cp_node_ips" {
  value   = google_compute_instance.cp_node.*.network_interface.0.network_ip
  description = "First IP of cp nodes"
}
