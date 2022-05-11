variable "operating_system" {
  type        = string
  description = "The Operating system to deploy (Only ubuntu_20_04 has been tested)"
}
variable "create_project" {
  type        = bool
  description = "Create a new Project if this is 'true'. Else use provided 'project_id'"
}
variable "project_name" {
  type        = string
  description = "The name of the project if 'create_project' is 'true'."
}
variable "project_id" {
  type        = string
  description = "The project ID to use (Same variable for GCP and EQM)"
}
variable "organization_id" {
  type        = string
  description = "Organization ID (GCP or EQM)"
}
variable "ssh_key" {
  type = object({
    public_key  = string
    private_key = string
  })
}

variable "gcp_cp_instance_type" {
  type        = string
  description = "The GCE instance type for control plane nodes"
}

variable "gcp_worker_instance_type" {
  type        = string
  description = "The GCE instance type for worker nodes"
}

variable "cluster_name" {
  type        = string
  description = "The GKE cluster name"
}
variable "gcp_zone" {
  type        = string
  description = "The GCE zone where the instances should reside"
}

variable "gcp_billing_account" {
  type        = string
  description = "The GCP billing account to use for the project"
}

variable "private_subnet" {
  type        = string
  description = "The private IP space for the cluster"
}

variable "cp_node_count" {
  type        = number
  description = "How many control plane nodes to deploy"
}

variable "worker_node_count" {
  type        = number
  description = "How many worker nodes to deploy"
}
