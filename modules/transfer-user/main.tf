locals {
  all_key_bodies = concat(
  var.transfer_ssh_key_bodys,
  data.aws_ssm_parameter.user_ssh_key.*.value,
  )
}


resource "aws_transfer_user" "this" {
  role                = var.create_iam_role ? element(concat(aws_iam_role.this.*.arn, [""]), 0) : var.iam_role_arn
  server_id           = var.transfer_server_id
  user_name           = var.user_name
  tags                = var.tags
  home_directory      = var.home_directory
  dynamic "home_directory_mappings" {
    for_each = lookup(var.home_directory_mappings, "entry", null) != null ? [var.home_directory_mappings] : []
    content {
      entry  = lookup(var.home_directory_mappings, "entry")
      target = lookup(var.home_directory_mappings, "target")
    }
  }
  home_directory_type = var.home_directory_type
}

resource "aws_transfer_ssh_key" "ssh_key" {
  count     = var.add_transfer_ssh_keys ? length(local.all_key_bodies) : 0
  body      = element(concat(local.all_key_bodies, [""]), count.index)
  server_id = var.transfer_server_id
  user_name = aws_transfer_user.this.user_name
}

resource "aws_iam_role" "this" {
  count              = var.create_iam_role ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
  name               = "Transfer-user-${var.user_name}"
  path = "/"
  tags = var.tags
}

resource "aws_iam_role_policy" "inline_policy" {
  count  = var.create_iam_role ? 1 : 0
  policy = data.aws_iam_policy_document.inline_policy[0].json
  role   = aws_iam_role.this[0].id
}

