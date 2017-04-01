output "private_subnet_ids" {
  value = "${split(",",module.private_subnet_nat.subnet_ids)}"
}

output "private_subnet_azs" {
  value = "${split(",", var.private_subnet_azs)}"
}

output "public_subnet_ids" {
  value = "${split(",",module.public_subnet.subnet_ids)}"
}

output "public_subnet_azs" {
  value = "${split(",", var.public_subnet_azs)}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr" {
  value = "${module.vpc.vpc_cidr}"
}

output "bastion_sg_id" {
  value = "${module.bastion.sg_from_bastion}"
}