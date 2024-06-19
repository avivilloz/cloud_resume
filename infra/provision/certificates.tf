resource "aws_acm_certificate" "static_website" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]
}

resource "aws_acm_certificate_validation" "static_website" {
  certificate_arn = aws_acm_certificate.static_website.arn
}
