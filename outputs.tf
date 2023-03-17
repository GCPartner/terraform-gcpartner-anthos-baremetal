output "ssh_command" {
  value       = local.ssh_command
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
  # TODO: Could possibly remove and use `network_details` instead
  value       = var.network_type == "private" ? local.priv_vlan_id : local.pub_vlan_id
  description = "The vLan ID for the server network"
}

output "subnet" {
  # TODO: Could possibly remove and use `network_details` instead
  value       = var.network_type == "private" ? local.priv_cidr : local.pub_cidr
  description = "The IP space for the cluster"
}

output "cluster_name" {
  value       = local.cluster_name
  description = "The name of the Anthos Cluster"
}
/*
output "kubeconfig" {
  sensitive   = true
  description = "The kubeconfig for the Anthos Cluster"
  value       = data.external.kubeconfig.result.content
}
*/
output "ssh_key" {
  sensitive   = true
  description = "SSH Public and Private Key"
  value       = local.ssh_key
}

output "network_details" {
  description = "The network details for the nodes"
  value = {
    primary_network = var.network_type == "private" ? "private_network" : "public_network"
    private_network = {
      id      = local.priv_net_id
      vlan_id = local.priv_vlan_id
      cidr    = local.priv_cidr
    }
    public_network = {
      id      = local.pub_net_id
      vlan_id = local.pub_vlan_id
      cidr    = local.pub_cidr
    }
  }
}

output "os_image" {
  value       = local.os_image
  description = "The OS Image used to build the nodes"
}
