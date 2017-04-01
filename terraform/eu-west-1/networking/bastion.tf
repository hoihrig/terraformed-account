module "bastion" {
  source               = "github.com/hoihrig/terraform-modules//aws/network/bastion?ref=master"
  instance_type        = "t2.nano"
  vpc_id               = "${module.vpc.vpc_id}"
  vpc_cidr             = "${module.vpc.vpc_cidr}"
  subnet_ids           = "${module.public_subnet.subnet_ids}"
  ami                  = "${data.aws_ami.bastion_ami.id}"
  region               = "${module.region.region}"
  user_data            = ""
  iam_instance_profile = ""
  key_name             = "${data.terraform_remote_state.global.hoih_keypair_name}"
}
