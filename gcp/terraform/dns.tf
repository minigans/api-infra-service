# DNS zone for the API infrastructure service
resource "google_dns_managed_zone" "api_service" {
  description   = "Public hosted zone for demo purposes"
  dns_name      = "mini.ping-fuji.com."
  name          = "savitha"
  project       = local.project_id
  visibility    = "public"
}