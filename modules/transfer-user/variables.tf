variable "transfer_server_id" {
  description = "ID of the AWs Transfer Server"
  default = ""
}

variable "user_name" {
  description = "User Name for Transfer User"
}

variable "create_iam_role" {
  description = "Create an IAM role for the module"
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
  type        = map(string)
}

variable "home_directory" {
  description = "specify home directory of Transnfer User"
  default     = ""
}

variable "add_transfer_ssh_keys" {
  description = "Setup Transfer User SSH Key"
  default     = false
}

variable "transfer_ssh_key_bodys" {
  description = "Public key part of SSH Key for Transfer user being created."
  default     = []
  type        = list(string)
}

variable "use_ssm" {
  description = "Whether to retrieve SSH key body from SSM parameters."
  default     = false
}

variable "transfer_ssh_key_ssm_paths" {
  description = "List of SSM Parameter store paths to retrieve public key from."
  type        = list(string)
  default     = ["/transfer/users/user"]
}

variable "home_directory_mappings" {
  description = "Logical directory mappings that specify what S3 paths and keys should be visible to your user and how you want to make them visible"
  default     = {}
  type        = map(string)
}

variable "home_directory_type" {
  description = "The type of landing directory (folder) you mapped for your users' home directory. Valid values are PATH and LOGICAL"
  default     = "PATH"
  type        = string
}

variable "create_transfer_user" {
  description = "Create an transfer user"
  default     = true
}