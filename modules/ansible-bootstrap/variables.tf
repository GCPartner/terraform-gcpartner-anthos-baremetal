variable "ssh_key" {
  type = object({
    public_key  = string
    private_key = string
  })
  description = "SSH Public and Private Key"
}

variable "bastion_ip" {
  type        = string
  description = "The bastion host/admin workstation public IP Address"
}

variable "cp_node_count" {
  type        = number
  description = "How many control plane nodes to deploy"
}

variable "worker_node_count" {
  type        = number
  description = "How many worker nodes to deploy"
}

variable "cp_ips" {
  type        = list
  description = "ips for control plane nodes"
}

variable "worker_ips" {
  type        = list
  description = "ips for worker nodes"
}

variable "private_subnet" {
  type        = string
  description = "The private IP space for the cluster"
}

variable "cluster_name" {
  type        = string
  description = "The ABM cluster name"
}

variable "abm_version" {
  type        = string
  description = "The version of Anthos Private Mode to install"
}

variable "operating_system" {
  type        = string
  description = "The Operating system to deploy (Only ubuntu_20_04 has been tested)"
}

variable "username" {
  type        = string
  description = "The username used to ssh to hosts"
}

variable "ansible_playbook_version" {
  type        = string
  description = "The version of the ansible playbook to install"
}
