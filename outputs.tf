output "response" {
  value = one(data.external.dns_validation[*].result)
}
