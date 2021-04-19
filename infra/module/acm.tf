resource "aws_acm_certificate" "certificate" {
  domain_name               = "*.${local.root_domain_name}"
  validation_method         = "DNS"
  subject_alternative_names = [local.root_domain_name]

  lifecycle {
    create_before_destroy = true
  }
}
