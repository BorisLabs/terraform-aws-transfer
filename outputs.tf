output "r53_record_fqdn" {
  value = "${element(concat(aws_route53_record.this.*.fqdn, list("")),0)}"
}

output "transfer_server_endpoint" {
  value = "${element(concat(aws_transfer_server.this.*.endpoint,list("")),0)}"
}
