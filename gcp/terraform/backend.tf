terraform {
  backend "gcs" {
    bucket = "api-infra-service"
    prefix = "terraform/state"
  }
}