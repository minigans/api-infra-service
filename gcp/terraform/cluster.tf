# API infrastructure GKE cluster
resource "google_container_cluster" "api_service_cluster" {
  name     = "savitha"
  project  = local.project_id

  workload_identity_config {
    workload_pool = "${local.project_id}.svc.id.goog"
  }
}