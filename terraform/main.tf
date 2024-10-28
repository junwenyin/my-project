# Resource: Generate a random string
resource "random_string" "example" {
  count = 4
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = true
}