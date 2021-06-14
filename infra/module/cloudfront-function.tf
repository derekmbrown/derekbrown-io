resource "aws_cloudfront_function" "rewrite_url" {
  name    = "rewrite-url"
  comment = "To rewrite urls"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/rewrite-url.js")
}
