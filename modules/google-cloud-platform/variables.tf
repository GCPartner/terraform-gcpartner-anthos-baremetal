variable "cluster_name" {
  type        = string
  description = "The ABM cluster name"
}

variable "gcp_project_id" {
  type        = string
  description = "The project ID to use (Same variable for GCP and EQM)"
}
