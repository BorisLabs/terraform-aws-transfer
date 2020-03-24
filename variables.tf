variable "create_transfer_server" {
  description = "Create the Transfer Server"
  default     = true
}

variable "create_transfer_logging_role" {
  description = "Create the IAM Role for logging"
  default     = true
}

variable "logging_role_name" {
  description = "Name of logging role to if creating one"
  default     = "default-transfer-server-role"
}

variable "logging_policy_name" {
  description = "Name of logging policy to create"
  default     = "default-transfer-server-policys"
}

variable "logging_role_arn" {
  description = "Arn of role to use to allow the service to log"
  default     = ""
}

variable "identity_provider_type" {
  description = "Type of identitiy provider used within the transfer service"
  default     = "SERVICE_MANAGED"
}

variable "tags" {
  description = "Tags to apply to resource"
  type        = map(string)
  default     = {}
}

variable "endpoint_type" {
  description = "The endpoint type for the transfer server"
  default     = "PUBLIC"
}

variable "internet_facing_eip" {
  description = "If your using a Internet Facing VPC Endpoint type creates EIPS"
  default     = false
}

variable "internet_facing_eip_count" {
  description = "Number of EIPs you wish to create"
  default     = 0
}

variable "create_route53_record" {
  description = "Whether to create the Route53 Record."
  default     = false
}

variable "route53_record_name" {
  description = "Route53 Record Name"
  default     = ""
}

variable "route53_record_zone" {
  description = "Route53 Zone ID"
  default     = ""
}

variable "transfer_server_endpoint_name" {
  description = "Option to create a R53 Record, added due to transfer server lacking VPC functionality"
  default     = []

  type = list(string)
}

variable "dns_role_arn" {
  description = "Route53 DNS role arn if applicable"
  default     = ""
}

variable "iam_path" {
  description = "IAM Path applied to IAM role"
  default     = ""
}

variable "aws_region" {
  description = "AWS region used in provider"
  default     = "eu-west-1"
}