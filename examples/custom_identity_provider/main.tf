provider "aws" {
  profile = "test-account-1"
  region  = "eu-west-1"
}

module "custom_identity_provider" {
  source                   = "../../modules/custom_identity_provider"
  create_lambda_iam_role   = true
  create_transfer_iam_role = true

  tags = {
    Project = "ModuleTesting"
  }
}

output "stage_invoke_url" {
  value = module.custom_identity_provider.transfer_identity_provider_url
}