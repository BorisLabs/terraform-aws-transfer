variable "create_transfer_server" {
  default = true
}

variable "logging_role_arn" {
}

variable "identity_provider_type" {
  default = "SERVICE_MANAGED"
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "endpoint_type" {
  default = "PUBLIC"
}

variable "create_route53_record" {
  default = false
}

variable "route53_record_name" {
  default = ""
}
variable "route53_record_zone" {
  default = ""
}