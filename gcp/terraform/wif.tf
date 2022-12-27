# The OIDC pool
resource "google_iam_workload_identity_pool" "oidc_pool" {
  provider                  = google-beta
  workload_identity_pool_id = "github-oidc-pool"
  project                   = local.project_id
  description               = "OIDC pool"
}

# The GitHub OIDC provider within the OIDC pool
resource "google_iam_workload_identity_pool_provider" "oidc_provider" {
  provider                           = google-beta
  project                            = local.project_id
  workload_identity_pool_provider_id = "github-provider"
  workload_identity_pool_id          = google_iam_workload_identity_pool.oidc_pool.workload_identity_pool_id
  description                        = "GitHub provider"

  attribute_mapping = {
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "google.subject"       = "assertion.sub"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com/"
  }
}

# The GitHub service account
resource "google_service_account" "github_sa" {
  account_id = "github"
  project    = local.project_id
}

# The project-wide IAM roles needed by the GitHub service account
resource "google_project_iam_member" "github_sa_project_roles" {
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.github_sa.email}"
  project = local.project_id
}

# Allow this GitHub repo to impersonate the GitHub service account through workload identity federation
resource "google_service_account_iam_member" "github_sa_iam" {
  service_account_id = google_service_account.github_sa.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${local.project_number}/locations/global/workloadIdentityPools/github-oidc-pool/attribute.repository/minigans/api-infra-service"
}