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

data "aws_ssm_parameter" "user_ssh_key" {
  count           = "${var.use_ssm? length(var.transfer_ssh_key_ssm_paths) : 0}"
  name            = "${element(var.transfer_ssh_key_ssm_paths,count.index)}"
  with_decryption = true
}
