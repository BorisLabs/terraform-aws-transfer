variable "create_lambda_iam_role" {
  description = "Create an IAM role for the Lambda execution"
  default     = true
  type        = bool
}

variable "lambda_role_arn" {
  description = "ARN of Lambda role if create_lambda_iam_role set to false"
  default     = ""
  type        = string
}

variable "create_transfer_iam_role" {
  description = "Create an IAM role for the Transfer server to use with permissions to invoke APIGateway REST API created here."
  default     = true
  type        = bool
}

variable "secret_base_path" {
  description = "SSM Parameter base path for secrets"
  default     = "SFTP/"
  type        = string
}

variable "tags" {
  description = "Tags to apply to supported resources"
  default     = {}
  type        = map(string)
}