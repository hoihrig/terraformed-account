# Configure the AWS Provider
provider "aws" {
  region              = "eu-west-1"
  allowed_account_ids = ["${module.global.account_id}"]
}

data "terraform_remote_state" "global" {
  backend = "s3"

  config {
    bucket  = "${module.global.terraform_state_bucket}"
    region  = "${module.global.default_region}"
    key     = "${module.global.remote_state_key}"
    encrypt = true
  }
}

data "aws_ami" "bastion_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-yakkety-16.10-amd64-server*"]
  }
}

module "global" {
  source = "../../global-vars"
}

module "region" {
  source = "../region-vars"
}
