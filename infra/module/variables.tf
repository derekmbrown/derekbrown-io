variable "domain_name" {}

locals {
  root_domain_name = var.domain_name
  www_domain_name  = "www.${var.domain_name}"
}
