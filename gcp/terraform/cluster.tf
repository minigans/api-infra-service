# API infrastructure GKE cluster
resource "google_container_cluster" "api_service_cluster" {
  lifecycle {
    ignore_changes = [authenticator_groups_config["security_group"]]
  }

  name     = "api-infra-service"
  project  = local.project_id
  location = "us-central1-a"

  initial_node_count = 3

  workload_identity_config {
    workload_pool = "${local.project_id}.svc.id.goog"
  }
}