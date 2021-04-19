resource "aws_route53_zone" "root" {
  name = local.root_domain_name
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.root.zone_id
  name    = local.root_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.root_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.root_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.root.zone_id
  name    = local.www_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.www_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.www_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
