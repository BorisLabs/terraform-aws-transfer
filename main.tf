resource "aws_transfer_server" "this" {
  count = var.create_transfer_server ? 1 : 0

  identity_provider_type = var.identity_provider_type
  logging_role           = var.create_transfer_logging_role == true ? aws_iam_role.logging[0].arn : var.logging_role_arn
  endpoint_type          = var.endpoint_type
  protocols              = var.protocols
  certificate            = var.certificate
  function               = var.function
  url                    = var.url
  invocation_role        = var.invocation_role
  endpoint_details {
    subnet_ids             = var.subnet_ids
    vpc_id                 = var.vpc_id
    security_group_ids     = var.security_group_ids
    address_allocation_ids = var.address_allocation_ids
  }

  tags = var.tags
}

resource "aws_route53_record" "this" {
  provider = aws.dns
  count    = var.create_route53_record ? 1 : 0

  name    = var.route53_record_name
  type    = "CNAME"
  zone_id = var.route53_record_zone
  records = [concat(aws_transfer_server.this[*].endpoint, var.transfer_server_endpoint_name)[0]]
  ttl     = 3600
}

resource "aws_iam_role" "logging" {
  count = var.create_transfer_logging_role ? 1 : 0

  name = var.logging_role_name
  path = var.iam_path

  assume_role_policy    = data.aws_iam_policy_document.trust_policy.json
  force_detach_policies = true

  tags = merge(var.tags, { Name = var.logging_role_name, Role = "${var.logging_role_name} iam role" })
}

resource "aws_iam_policy" "logging" {
  count = var.create_transfer_logging_role ? 1 : 0

  name   = var.logging_policy_name
  path   = var.iam_path
  policy = data.aws_iam_policy_document.logging.json

  tags = merge(var.tags, { Name = var.logging_policy_name, Role = var.logging_policy_name })
}

resource "aws_eip" "this" {
  count = var.internet_facing_eip ? var.internet_facing_eip_count : 0
  tags  = var.tags
}