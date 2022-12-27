locals {
  tf_sa = "org-terraform@prj-b-seed-d730.iam.gserviceaccount.com"
}

provider "google" {
  alias = "impersonate"

  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "default" {
  provider               = google.impersonate
  target_service_account = local.tf_sa
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "600s"
}

provider "google" {
  access_token = data.google_service_account_access_token.default.access_token
  region       = local.region
}

provider "google-beta" {
  access_token = data.google_service_account_access_token.default.access_token
  region       = local.region
}