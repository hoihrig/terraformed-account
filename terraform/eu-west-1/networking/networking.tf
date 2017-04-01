module "vpc" {
  source = "github.com/comoyo/terraform-modules//aws/network/vpc?ref=master"
  name   = "${var.vpc_name}"
  cidr   = "${var.vpc_cidr}"
}

module "igw" {
  source = "github.com/comoyo/terraform-modules//aws/network/igw?ref=master"
  vpc_id = "${module.vpc.vpc_id}"
}

module "public_subnet" {
  source = "github.com/comoyo/terraform-modules//aws/network/public_subnet?ref=master"
  cidrs  = "${var.public_subnet_cidrs}"
  azs    = "${var.public_subnet_azs}"
  vpc_id = "${module.vpc.vpc_id}"
  igw_id = "${module.igw.igw_id}"
}

module "private_subnet_nat" {
  source = "github.com/comoyo/terraform-modules//aws/network/private_subnet_nat?ref=master"
  cidrs  = "${var.private_subnet_cidrs}"
  azs    = "${var.private_subnet_azs}"
  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_eip" "nat-eip" {
  count = "${length(split(",", var.public_subnet_cidrs))}"
  vpc   = true
}

resource "aws_nat_gateway" "nat-gw" {
  count         = "${length(split(",", var.public_subnet_cidrs))}"
  allocation_id = "${element(aws_eip.nat-eip.*.id, count.index)}"
  subnet_id     = "${element(split(",", module.public_subnet.subnet_ids), count.index)}"
}

resource "aws_route" "nat-gw-route" {
  count                  = "${length(split(",", var.public_subnet_cidrs))}"
  route_table_id         = "${element(split(",", module.private_subnet_nat.private_route_table_ids), count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat-gw.*.id, count.index)}"
}

resource "aws_vpc_endpoint" "private-s3" {
  vpc_id       = "${module.vpc.vpc_id}"
  service_name = "com.amazonaws.${module.region.region}.s3"

  route_table_ids = ["${module.vpc.vpc_main_route}",
    "${split(",", module.private_subnet_nat.private_route_table_ids)}",
  ]
}
