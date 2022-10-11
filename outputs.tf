output "ssh_command" {
  value       = format("ssh -i %s %s@%s", pathexpand(format("~/.ssh/%s", local.ssh_key_name)), local.username, local.bastion_ip)
  description = "Command to run to SSH into the bastion host"
}

output "ssh_key_path" {
  value       = pathexpand(format("~/.ssh/%s", local.ssh_key_name))
  description = "Path to the SSH Private key for the bastion host"
}

output "bastion_host_ip" {
  value       = local.bastion_ip
  description = "IP Address of the bastion host in the test environment"
}

output "bastion_host_username" {
  value       = local.username
  description = "Username for the bastion host in the test environment"
}

output "vlan_id" {
  value       = local.vlan_id
  description = "The vLan ID for the private network"
}

output "subnet" {
  value       = local.subnet
  description = "The IP space for the cluster"
}

output "cluster_name" {
  value = local.cluster_name
  description = "The name of the Anthos Cluster"
}
