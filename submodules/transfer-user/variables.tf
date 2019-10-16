variable "transfer_server_id" {
  description = "ID of the AWs Transfer Server"
}

variable "user_name" {
  description = "User Name for Transfer User"
}

variable "create_iam_role" {
  description = "TODO... Create an IAM role for the module"
  default     = false
}

variable "iam_role_policy_statements" {
  description = "JSON of iam policy statements"
  default     = ""
}

variable "iam_role_arn" {
  description = "ARN of IAM role. requires create_iam_role = false"
  default     = ""
}

variable "tags" {
  description = "Tags to attach to transfer user"
  default     = {}
  type        = "map"
}

variable "home_directory" {
  description = "specify home directory of Transnfer User"
  default     = ""
}