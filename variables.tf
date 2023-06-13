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

variable "protocols" {
  description = "Specifies the file transfer protocol or protocols over which your file transfer protocol client can connect to your server's endpoint"
  default     = ["SFTP"]
  type        = list(string)
}

variable "certificate" {
  description = "The Amazon Resource Name (ARN) of the AWS Certificate Manager (ACM) certificate"
  default     = ""
}

variable "function" {
  description = "The ARN for a lambda function to use for the Identity provider"
  default     = ""
}

variable "url" {
  description = "URL of the service endpoint used to authenticate users with an identity_provider_type of API_GATEWAY"
  default     = ""
}

variable "invocation_role" {
  description = "Amazon Resource Name (ARN) of the IAM role used to authenticate the user account with an identity_provider_type of API_GATEWAY"
  default     = ""
}

variable "address_allocation_ids" {
  description = "A list of address allocation IDs that are required to attach an Elastic IP address to your SFTP server's endpoint. This property can only be used when endpoint_type is set to VPC"
  default     = []
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security groups IDs that are available to attach to your server's endpoint. If no security groups are specified, the VPC's default security groups are automatically assigned to your endpoint. This property can only be used when endpoint_type is set to VPC."
  default     = []
  type        = list(string)
}

variable "subnet_ids" {
  description = "A list of subnet IDs that are required to host your SFTP server endpoint in your VPC. This property can only be used when endpoint_type is set to VPC"
  default     = []
  type        = list(string)
}

variable "vpc_endpoint_id" {
  description = "The ID of the VPC endpoint. This property can only be used when endpoint_type is set to VPC_ENDPOINT"
  default     = ""
}

variable "vpc_id" {
  description = "The VPC ID of the virtual private cloud in which the SFTP server's endpoint will be hosted. This property can only be used when endpoint_type is set to VPC."
  default     = ""
}

variable "security_policy_name" {
  description = "Specifies the name of the security policy that is attached to the server"
  default     = "TransferSecurityPolicy-2018-11"
}