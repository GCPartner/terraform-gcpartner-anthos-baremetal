variable "operating_system" {
  type        = string
  description = "The Operating system to deploy (Only ubuntu_20_04 has been tested)"
}

variable "cluster_name" {
  type        = string
  description = "The ABM cluster name"
}

variable "pnap_location" {
  type        = string
  description = "PhoenixNAP Location to deploy into"
}

variable "cp_node_count" {
  type        = number
  description = "How many control plane nodes to deploy"
}

variable "worker_node_count" {
  type        = number
  description = "How many worker nodes to deploy"
}

variable "pnap_cp_type" {
  type        = string
  description = "PhoenixNAP server type to deploy for control plane nodes"
}

variable "pnap_worker_type" {
  type        = string
  description = "PhoenixNAP server type to deploy for worker nodes"
}

variable "ssh_key" {
  type = object({
    public_key  = string
    private_key = string
  })
  description = "SSH Public and Private Key"
}

variable "private_subnet" {
  type        = string
  description = "The private IP space for the cluster"
}

variable "create_network" {
  type        = bool
  description = "Create a new network if this is 'true'. Else use provided 'p*_network_id'"
}

variable "public_network_id" {
  type        = string
  description = "If create_network=false, this will be the public network used for the deployment. (Only supported in PNAP today)"
}

variable "private_network_id" {
  type        = string
  description = "If create_network=false, this will be the private network used for the deployment. (Only supported in PNAP today)"
}

variable "network_type" {
  type        = string
  description = "Deploy the nodes on a 'private' or 'public' network. (Only supported in PNAP today)"
}
