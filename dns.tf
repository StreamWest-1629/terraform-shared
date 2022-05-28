locals {
  primary = "kasai-san.dev"
}

resource "aws_route53_zone" "primary" {
  name = local.primary
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    ProjectName = var.PROJECT_NAME
  }
}

resource "aws_acm_certificate" "primary" {
  domain_name = "*.${local.primary}"
  lifecycle {
    prevent_destroy = true
  }
}

output "primary_hostzone" {
  value = aws_route53_zone.primary
}

output "primary_zoneid" {
  value     = aws_route53_zone.primary.id
  sensitive = true
}

output "primary_certarn" {
  value = aws_acm_certificate.primary.arn
}
