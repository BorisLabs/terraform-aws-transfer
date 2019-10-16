resource "aws_transfer_user" "this" {
  role           = "${var.create_iam_role? aws_iam_role.this.arn : var.iam_role_arn}"
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
  policy = "${data.aws_iam_policy_document.inline_policy.json}"
  role   = "${aws_iam_role.this.id}"
}
