
resource "aws_acm_certificate" "default" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.with_wildcard_subdomain ? ["*.${var.domain_name}"] : []

  lifecycle {
    create_before_destroy = false
  }

  tags = var.acm_tags
}

data "cloudflare_zone" "default" {
  name = var.domain_name
}

resource "cloudflare_record" "default" {
  zone_id = data.cloudflare_zone.default.zone_id
  type    = tolist(aws_acm_certificate.default.domain_validation_options)[0].resource_record_type
  name    = tolist(aws_acm_certificate.default.domain_validation_options)[0].resource_record_name
  value   = tolist(aws_acm_certificate.default.domain_validation_options)[0].resource_record_value
  comment = var.cloudflare_dns_record_comment
}

resource "aws_acm_certificate_validation" "default" {
  certificate_arn = aws_acm_certificate.default.arn
  depends_on = [
    aws_acm_certificate.default,
    cloudflare_record.default
  ]
}
