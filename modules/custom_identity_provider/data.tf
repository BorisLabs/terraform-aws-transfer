data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    effect  = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}
data "aws_iam_policy_document" "transfer_trust_policy" {
  statement {
    effect  = "Allow"
    principals {
      identifiers = ["transfer.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_inline_policy" {
  count = var.create_lambda_iam_role ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.secret_base_path}/*"
    ]
  }
}

data "aws_iam_policy_document" "transfer_inline_policy" {
  count = var.create_transfer_iam_role ? 1 : 0

  statement {
    sid       = "AllowTransferInvokeApi"
    effect    = "Allow"
    actions   = [
      "execute-api:Invoke"
    ]
    resources = [
      "${aws_api_gateway_stage.prod.execution_arn}/GET/*"
    ]
  }

  statement {
    sid       = "AllowTransferReadAPI"
    effect    = "Allow"
    actions   = [
      "apigateway:GET"
    ]
    resources = ["*"]

  }
}