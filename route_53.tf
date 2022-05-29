locals {
  primary_zone = "kasai-san.dev"
}

resource "aws_route53_zone" "primary" {
  name = local.primary_zone
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    ProjectName = var.PROJECT_NAME
  }
}

resource "aws_acm_certificate" "primary" {
  domain_name       = "*.${local.primary_zone}"
  validation_method = "DNS"
  lifecycle {
    prevent_destroy = true
  }
}

output "host_primary_zonename" {
  value = aws_route53_zone.primary.name
}

output "host_primary_zoneid" {
  value     = aws_route53_zone.primary.id
  sensitive = true
}

output "host_primary_certarn" {
  value = aws_acm_certificate.primary.arn
  sensitive = true
}

resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.primary.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.primary.id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 300
}

resource "aws_route53_record" "docs" {
  zone_id = aws_route53_zone.primary.id
  name    = "docs.${local.primary_zone}"
  records = ["streamwest-1629.github.io"]
  type    = "CNAME"
  ttl     = 300
}
