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

variable "transfer_iam_role_name" {
  description = "Transfer server IAM role name"
  default     = "TransferCustomIdentityProviderRole"
  type        = string
}

variable "lambda_iam_role_name" {
  description = "Lambda IAM role name"
  default     = "TransferCustomIdentityProviderLambdaRole"
  type        = string
}

variable "api_gateway_rest_api_name" {
  default     = "Transfer Custom Identity Provider"
  description = "Name of the REST API"
  type        = string
}

variable "api_gateway_stage_name" {
  default     = "prod"
  description = "Name of the stage"
  type        = string
}