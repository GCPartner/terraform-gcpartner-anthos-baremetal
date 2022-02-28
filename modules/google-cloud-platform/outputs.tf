output "gcp_sa_keys" {
  value       = tomap({for k, v in google_service_account_key.sa_keys: k => v.private_key})
  description = "GCP Service Account JSON Keys"
}
