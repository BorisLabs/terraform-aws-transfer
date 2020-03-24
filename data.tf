data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["transfer.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "logging" {
  statement {
    sid    = "SFTPLoggingTrust"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
}
