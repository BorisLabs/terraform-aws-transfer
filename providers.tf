provider "aws" {
  region = var.aws_region
  alias  = "dns"
  assume_role {
    role_arn = var.dns_role_arn
  }
}
