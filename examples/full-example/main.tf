provider "aws" {
  region  = "eu-west-1"
  profile = "test-account-1"
}
module "server" {
  source = "../server-and-r53"
}

resource "aws_s3_bucket" "home_bucket" {}


data aws_iam_policy_document "user_role_policy_statements" {
  statement {
    sid       = "AllowS3Access"
    actions   = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    effect    = "Allow"
    resources = [aws_s3_bucket.home_bucket.arn]
  }
  statement {
    sid       = "PutObjectPermission"
    actions   = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObjectVersion",
      "s3:DeleteObject",
      "s3:GetObjectVersion"
    ]
    effect    = "Allow"
    resources = [
      "${aws_s3_bucket.home_bucket.arn}/folder/*"
    ]
  }
  statement {
    sid       = "KMSPerms"
    actions   = [
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:Decrypt"
    ]
    effect    = "Allow"
    resources = [
      "*"
    ]
  }
}

module "user" {
  source                     = "../../modules/transfer-user"
  transfer_server_id         = module.server.server_id
  user_name                  = "test-user-1"
  create_iam_role            = true
  add_transfer_ssh_keys      = true
  use_ssm                    = true
  transfer_ssh_key_ssm_paths = ["/test/base/path/test-user-1"]
  home_directory_mappings    = {
    entry  = "/"
    target = "/${aws_s3_bucket.home_bucket.bucket}/test/homedir"
  }
  home_directory_type        = "LOGICAL"
  iam_role_policy_statements = data.aws_iam_policy_document.user_role_policy_statements.json
}

module "user_no_homedir_mapping" {
  source                     = "../../modules/transfer-user"
  transfer_server_id         = module.server.server_id
  user_name                  = "test-user-2"
  create_iam_role            = true
  add_transfer_ssh_keys      = true
  use_ssm                    = true
  transfer_ssh_key_ssm_paths = ["/test/base/path/test-user-1"]
  home_directory             = "/${aws_s3_bucket.home_bucket.bucket}/test/homedir"
  iam_role_policy_statements = data.aws_iam_policy_document.user_role_policy_statements.json
}
