resource "aws_transfer_server" "this" {
  count = "${var.create_transfer_server? 1 : 0}"

  identity_provider_type = "${var.identity_provider_type}"
  logging_role           = "${var.logging_role_arn}"

  endpoint_type = "${var.endpoint_type}"

  tags = "${var.tags}"
}

resource "aws_route53_record" "this" {
  provider = "aws.dns"
  count   = "${var.create_route53_record ? 1 : 0}"
  name    = "${var.route53_record_name}"
  type    = "CNAME"
  zone_id = "${var.route53_record_zone}"
  records = ["${element(concat(aws_transfer_server.this.*.endpoint, list("")), 0)}"]
  ttl     = 3600
}
