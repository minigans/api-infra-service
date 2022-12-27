# DNS zone for the API infrastructure service
resource "google_dns_managed_zone" "api_service" {
  description = "Public hosted zone for demo purposes"
  dns_name    = "api.ping-fuji.com."
  name        = "api-service-zone"
  project     = local.project_id
  visibility  = "public"
}