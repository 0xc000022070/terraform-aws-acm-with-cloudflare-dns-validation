
variable "domain_name" {
  type = string
}

variable "with_wildcard_subdomain" {
  type    = bool
  default = false
}

variable "acm_tags" {
  type = map(string)
}

variable "cloudflare_dns_record_comment" {
  type = string
}
