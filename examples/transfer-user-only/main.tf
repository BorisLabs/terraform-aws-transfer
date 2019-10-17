provider "aws" {
  region  = "eu-west-1"
  profile = "test-account-2"
}

module "user" {
  source                    = "../../submodules/transfer-user"
  transfer_server_id        = "s-1234ab56d32c11222"
  user_name                 = "test-user-1"
  add_transfer_ssh_keys     = true
  use_ssm                   = true
  transfer_ssh_key_ssm_path = "/test/base/path/test-user-1"
}
