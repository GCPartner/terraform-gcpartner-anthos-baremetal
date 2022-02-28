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
