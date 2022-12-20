# GCP service accounts for cert-manager and external-dns
resource "google_service_account" "cert_manager_sa" {
  account_id = "cert-manager"
  project    = local.project_id
}

resource "google_service_account" "external_dns_sa" {
  account_id = "external-dns"
  project    = local.project_id
}

# The project-wide IAM roles needed by the service accounts
resource "google_project_iam_member" "cert_manager_project_roles" {
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.cert_manager_sa.email}"
  project = local.project_id
}

resource "google_project_iam_member" "external_dns_project_roles" {
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.external_dns_sa.email}"
  project = local.project_id
}

# Allow the Kubernetes service accounts to impersonate the GCP service accounts as a workload identity user
resource "google_service_account_iam_member" "cert_manager_sa_iam" {
  service_account_id = google_service_account.cert_manager_sa.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${local.project_id}.svc.id.goog[cert-manager/cert-manager]"
}

resource "google_service_account_iam_member" "external_dns_sa_iam" {
  service_account_id = google_service_account.external_dns_sa.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${local.project_id}.svc.id.goog[external-dns/external-dns]"
}