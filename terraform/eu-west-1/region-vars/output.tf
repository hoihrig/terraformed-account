variable "region" {
  default = "eu-west-1"
}

output "region" {
  value = "${var.region}"
}

output "terraform_remote_state_networking_key" {
  value = "${var.region}-networking"
}

output "networking_remote_state_key" {
  value = "${var.region}-networking"
}

output "subnet_azs" {
  value = "${var.region}a,${var.region}b,${var.region}c"
}
