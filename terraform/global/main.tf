# Configure the AWS Provider
provider "aws" {
  region              = "${module.global.default_region}"
  allowed_account_ids = ["${module.global.account_id}"]   #Enter your account ID here
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "${module.global.terraform_state_bucket}"

  versioning {
    enabled = true
  }
}

module "global" {
  source = "../global-vars"
}
