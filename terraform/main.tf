# Resource: Generate a random string
resource "random_string" "example" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
}