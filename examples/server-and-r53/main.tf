provider "aws" {
  region  = "eu-west-1"
  profile = "test-account-2"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    principals {
      identifiers = ["transfer.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "cw_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]

    resources = ["*"]
  }
}

resource "aws_route53_zone" "test" {
  name = "test-zone.co.uk"
}
resource "aws_iam_role" "logging" {
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

module "test" {
  source                = "../.."
  logging_role_arn      = "${aws_iam_role.logging.arn}"
  create_route53_record = true
  route53_record_zone   = "${aws_route53_zone.test.zone_id}"
  route53_record_name   = "sftp.test-zone.co.uk"
}

output "r53_record_fqdn" {
  value = "${module.test.r53_record_fqdn}"
}

