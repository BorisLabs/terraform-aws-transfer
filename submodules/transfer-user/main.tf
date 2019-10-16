resource "aws_transfer_user" "this" {
  role           = "${var.create_iam_role? element(concat(aws_iam_role.this.*.arn,list("")),0) : var.iam_role_arn}"
  server_id      = "${var.transfer_server_id}"
  user_name      = "${var.user_name}"
  tags           = "${var.tags}"
  home_directory = "${var.home_directory}"
}


data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect  = "Allow"
    principals {
      identifiers = ["transfer.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "inline_policy" {
  count         = "${var.create_iam_role? 1 : 0}"
  override_json = "${var.iam_role_policy_statements}"
}

resource "aws_iam_role" "this" {
  count              = "${var.create_iam_role? 1 : 0}"
  assume_role_policy = "${data.aws_iam_policy_document.trust_policy.json}"
  name               = "Transfer-user-${var.user_name}"
}

resource "aws_iam_role_policy" "inline_policy" {
  count  = "${var.create_iam_role? 1 : 0}"
  policy = "${data.aws_iam_policy_document.inline_policy.json}"
  role   = "${aws_iam_role.this.id}"
}


resource "aws_transfer_ssh_key" "ssh_key" {
  count     = "${var.add_transfer_ssh_keys ? local.keys_count : 0}"
  body      = "${var.use_ssm ? local.ssm_ssh_key_value : element(concat(var.transfer_ssh_key_bodys,list("")),count.index)}"
  server_id = "${var.transfer_server_id}"
  user_name = "${aws_transfer_user.this.user_name}"
}

locals {
  ssm_ssh_key_value = "${element(concat(data.aws_ssm_parameter.user_ssh_key.*.value, list("")),0)}"
  keys_count        = "${var.use_ssm ? 1 : length(var.transfer_ssh_key_bodys)}"
}

data "aws_ssm_parameter" "user_ssh_key" {
  count           = "${var.use_ssm? 1 : 0}"
  name            = "${var.transfer_ssh_key_ssm_path}"
  with_decryption = true
}

