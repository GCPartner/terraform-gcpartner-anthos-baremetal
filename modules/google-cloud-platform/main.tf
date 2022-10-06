locals {
  enabled_apis = [
    "anthos.googleapis.com",
    "anthosaudit.googleapis.com",
    "anthosgke.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "iam.googleapis.com",
    "opsconfigmonitoring.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "serviceusage.googleapis.com",
    "stackdriver.googleapis.com"
  ]
  service_accounts = [
    "gcr",
    "connect",
    "register",
    "cloud-ops",
    "bmctl"
  ]
  role_map = [
    { role = "roles/gkehub.connect", service_account = "connect" },
    { role = "roles/gkehub.admin", service_account = "register" },
    { role = "roles/logging.logWriter", service_account = "cloud-ops" },
    { role = "roles/monitoring.metricWriter", service_account = "cloud-ops" },
    { role = "roles/stackdriver.resourceMetadata.writer", service_account = "cloud-ops" },
    { role = "roles/monitoring.dashboardEditor", service_account = "cloud-ops" },
    { role = "roles/opsconfigmonitoring.resourceMetadata.writer", service_account = "cloud-ops" },
    { role = "roles/compute.viewer", service_account = "bmctl" }
  ]
}

resource "google_project_service" "enabled-apis" {
  for_each           = toset(local.enabled_apis)
  service            = each.value
  disable_on_destroy = false
}

resource "google_service_account" "service_accounts" {
  for_each     = toset(local.service_accounts)
  account_id   = format("%s-%s", var.cluster_name, each.value)
  display_name = format("Anthos Bare Metal Service Account for %s %s", var.cluster_name, each.value)
}

resource "google_project_iam_member" "role_assignment" {
  for_each = { for role in local.role_map : role.role => role }
  role     = each.key
  member   = format("serviceAccount:%s", google_service_account.service_accounts[each.value.service_account].email)
  project  = var.gcp_project_id
}

resource "google_service_account_key" "sa_keys" {
  for_each           = toset(local.service_accounts)
  service_account_id = google_service_account.service_accounts[each.value].name
}
