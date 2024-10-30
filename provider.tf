# Configure the AliCloud Provider
provider "alicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  # If not set, cn-beijing will be used.
  region = "me-central-1"
}
