resource "aws_s3_bucket" "root" {
  bucket        = local.root_domain_name
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  logging {
    target_bucket = aws_s3_bucket.site_logs.id
    target_prefix = "${local.root_domain_name}/s3/root/"
  }
}

resource "aws_s3_bucket_public_access_block" "root" {
  bucket = aws_s3_bucket.root.id
}

resource "aws_s3_bucket_metric" "root" {
  bucket = aws_s3_bucket.root.bucket
  name   = "RootSiteMetrics"

  filter {
    prefix = "${local.root_domain_name}/s3/root/"
  }
}

resource "aws_s3_bucket_policy" "root" {
  bucket = aws_s3_bucket.root.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "",
  "Statement": [
    {
      "Sid": "AllowAccessToRootS3Site",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.root.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "www" {
  bucket        = local.www_domain_name
  acl           = "public-read"
  force_destroy = true

  website {
    redirect_all_requests_to = "https://${local.root_domain_name}"
  }

  logging {
    target_bucket = aws_s3_bucket.site_logs.id
    target_prefix = "${local.root_domain_name}/s3/www/"
  }
}

resource "aws_s3_bucket_public_access_block" "www" {
  bucket = aws_s3_bucket.www.id
}

resource "aws_s3_bucket_metric" "www" {
  bucket = aws_s3_bucket.root.bucket
  name   = "WwwSiteMetrics"

  filter {
    prefix = "${local.root_domain_name}/s3/www/"
  }
}

resource "aws_s3_bucket_policy" "www" {
  bucket = aws_s3_bucket.www.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "",
  "Statement": [
    {
      "Sid": "AllowAccessToWWWS3Site",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.www.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "site_logs" {
  bucket        = "${local.root_domain_name}-logs"
  acl           = "log-delivery-write"
  force_destroy = true

  lifecycle_rule {
    id      = "archive-logs"
    enabled = true

    prefix = "derekbrown.io/"

    transition {
      days          = 2
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "site_logs" {
  bucket                  = aws_s3_bucket.site_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "s3_website_endpoint" {
  value = aws_s3_bucket.root.website_endpoint
}
