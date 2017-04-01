variable "vpc_name" {
  description = "VPC name to be used in this region"
}

variable "vpc_cidr" {
  description = "VPC CIDR Block to be used in this region"
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDR Blocks to be used as comma seperated list (e.g. '10.2.x.y,10.2.z.n')"
}

variable "public_subnet_azs" {
  description = "Availability Zones used for Public Subnets, has to be comma separated and same amount as subnet cidrs"
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDR Blocks to be used as comma seperated list (e.g. '10.2.x.y,10.2.z.n')"
}

variable "private_subnet_azs" {
  description = "Availability Zones used for Private Subnets, has to be comma separated and same amount as subnet cidrs"
}
