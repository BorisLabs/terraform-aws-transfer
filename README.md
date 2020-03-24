# terraform-aws-transfer
Terraform Module for AWS Transfer for SFTP.  

This module aims to cover all connotations of setting up a AWS Transfer for SFTP Server along with users. 

The following resources are supported:
* aws_transfer_server
* aws_transfer_user
* aws_transfer_ssh_key

This Module will optionally create a Route53 CNAME Record for the server endpoint & also the IAM logging role. There's also some ability to create an internet facing Transfer service using the VPC.
Terraform doesn't currently support this functionality, but this current PR is open [Terraform PR]("https://github.com/terraform-providers/terraform-provider-aws/pull/11751)


## Usage
```hcl-terraform
module "transfer_server" {
  source                = "../.."
  logging_role_arn      = "arn:aws:iam::123456789012:role/custom/sftp-transfer-logging-role"
  create_route53_record = true
  route53_record_zone   = "ZABCD123456"
  route53_record_name   = "sftp.example.co.uk"
}

module "transfer_user_ssm_key_body" {
  source                    = "../../submodules/transfer-user"
  transfer_server_id        = "${module.transfer_server.transfer_server_id}"
  user_name                 = "test-user-1"
  add_transfer_ssh_keys     = true
  use_ssm                   = true
  transfer_ssh_key_ssm_path = "/test/base/path/test-user-1"
}

module "transfer_user_key_bodys" {
  source                    = "../../submodules/transfer-user"
  transfer_server_id        = "${module.transfer_server.transfer_server_id}"
  user_name                 = "test-user-2-multi-keys"
  add_transfer_ssh_keys     = true
  transfer_ssh_key_bodys    = ["ssh-rsa aakmsdfkmsfgoker132443t909doweWFSMLKSEF", "ssh-rsa alksmafgk232939ASDOSEFOANOSAEF"]
}

```


## Examples
- [Transfer Server and R53 Record](https://github.com/BorisLabs/terraform-aws-transfer/tree/master/examples/server-and-r53)
    * This example creates an IAM logging role and R53 zone also
- [Transfer User only](https://github.com/BorisLabs/terraform-aws-transfer/tree/master/examples/transfer-user-only)


## Terraform Versions
This module supports Terraform v0.11 from v0.0.1
This module supports Terraform v0.12

## Authors
Module managed by  
[Rob Houghton](https://github.com/ALLFIVE)  
[Josh Sinfield](https://github.com/JoshiiSinfield)  
[Ben Arundel](https://github.com/barundel)

## Notes
