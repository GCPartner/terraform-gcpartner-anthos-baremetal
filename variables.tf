variable "cloud" {
  type        = string
  default     = "GCP"
  description = "GCP (Google Cloud Platform), EQM (Equinx Metal), or PNAP (Phoenix Nap) to deploy the 'Nodes'"
}

variable "organization_id" {
  type        = string
  default     = "null"
  description = "Organization ID (GCP or EQM)"
}

variable "operating_system" {
  type        = string
  default     = "ubuntu_20_04"
  description = "The Operating system to deploy (Only ubuntu_20_04 has been tested)"
}

variable "cluster_name" {
  type        = string
  default     = "abm-cluster"
  description = "The ABM cluster name"
}

variable "create_project" {
  type        = bool
  default     = false
  description = "Create a new Project if this is 'true'. Else use provided 'project_id' (Unsuported for PNAP)"
}

variable "project_name" {
  type        = string
  default     = "abm-lab"
  description = "The name of the project if 'create_project' is 'true'."
}

variable "private_subnet" {
  type        = string
  default     = "172.31.254.0/24"
  description = "The private IP space for the cluster"
}

variable "ha_control_plane" {
  type        = bool
  default     = true
  description = "Do you want a highly available control plane"
}

variable "worker_node_count" {
  type        = number
  default     = 3
  description = "How many worker nodes to deploy"
}

variable "network_type" {
  type        = string
  default     = "public"
  description = "Deploy the nodes on a 'private' or 'public' network. (Only supported in PNAP today)"
}

variable "create_network" {
  type        = bool
  default     = true
  description = "Create a new network if this is 'true'. Else use provided 'p*_network_id'"
}

variable "public_network_id" {
  type        = string
  default     = "null"
  description = "If create_network=false, this will be the public network used for the deployment. (Only supported in PNAP today)"
}

variable "private_network_id" {
  type        = string
  default     = "null"
  description = "If create_network=false, this will be the private network used for the deployment. (Only supported in PNAP today)"
}

# Ansible Vars
variable "ansible_playbook_version" {
  type        = string
  description = "The version of the ansible playbook to install"
  default     = "v1.0.1"
}

variable "ansible_url" {
  type        = string
  description = "URL of the ansible code"
  default     = "https://github.com/GCPartner/ansible-gcpartner-anthos-baremetal/archive/refs/tags/v1.0.1.tar.gz"
}

variable "ansible_tar_ball" {
  type        = string
  description = "Tarball of the ansible code"
  default     = "v1.0.1.tar.gz"
}

# PhoenixNAP Vars
variable "pnap_client_id" {
  type        = string
  description = "PhoenixNAP API ID"
  default     = "null"
}

variable "pnap_client_secret" {
  type        = string
  description = "PhoenixNAP API Secret"
  default     = "null"
}

variable "pnap_location" {
  type        = string
  default     = "ASH"
  description = "PhoenixNAP Location to deploy into"
}

variable "pnap_cp_type" {
  type        = string
  description = "PhoenixNAP server type to deploy for control plane nodes"
  default     = "s2.c1.medium"
}

variable "pnap_worker_type" {
  type        = string
  description = "PhoenixNAP server type to deploy for worker nodes"
  default     = "s2.c1.medium"
}

# GCP Vars
variable "gcp_project_id" {
  type        = string
  default     = "null"
  description = "The project ID for GCP"
}

variable "gcp_cp_instance_type" {
  type        = string
  default     = "e2-standard-8"
  description = "The GCE instance type for control plane nodes"
}

variable "gcp_worker_instance_type" {
  type        = string
  default     = "e2-standard-8"
  description = "The GCE instance type for worker nodes"
}

variable "gcp_zone" {
  type        = string
  default     = "us-central1-a"
  description = "The GCE zone where the instances should reside"
}

variable "gcp_billing_account" {
  type        = string
  default     = "null"
  description = "The GCP billing account to use for the project"
}

# Equinix Metal Vars
variable "metal_auth_token" {
  type        = string
  description = "Equinix Metal API Key"
  default     = "null"
}

variable "metal_project_id" {
  type        = string
  default     = "null"
  description = "The project ID to use for EQM"
}

variable "metal_facility" {
  type        = string
  default     = "ny5"
  description = "Equinix Metal Facility to deploy into"
}

variable "metal_cp_plan" {
  type        = string
  default     = "c3.small.x86"
  description = "Equinix Metal device type to deploy for cp nodes"
}

variable "metal_worker_plan" {
  type        = string
  default     = "c3.small.x86"
  description = "Equinix Metal device type to deploy for worker nodes"
}

variable "metal_billing_cycle" {
  type        = string
  default     = "hourly"
  description = "How the node will be billed (Not usually changed)"
}
