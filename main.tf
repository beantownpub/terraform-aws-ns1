data "external" "dns_validation" {
  count   = var.enabled ? 1 : 0
  program = ["bash", "${path.module}/scripts/ns1.sh"]
  query = {
    api_key      = var.ns1_api_key
    cname_record = var.cname_record
    cname_target = var.cname_target
    zone         = var.dns_zone
  }
}
