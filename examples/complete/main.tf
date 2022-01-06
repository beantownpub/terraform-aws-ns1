provider "aws" {
  region = "us-west-2"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.dns_zone}"
  validation_method = "DNS"

  tags = {
    Zone = var.dns_zone
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "create_record" {
  source = "../.."

  ns1_api_key      = var.ns1_api_key
  cname_record = one(aws_acm_certificate.cert.domain_validation_options[*]).resource_record_name
  cname_target = one(aws_acm_certificate.cert.domain_validation_options[*]).resource_record_value
  dns_zone         = var.dns_zone
}
