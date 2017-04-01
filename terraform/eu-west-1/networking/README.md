
## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| vpc_name | VPC name to be used in this region | - | yes |
| vpc_cidr | VPC CIDR Block to be used in this region | - | yes |
| public_subnet_cidrs | Public Subnet CIDR Blocks to be used as comma seperated list (e.g. '10.2.x.y,10.2.z.n') | - | yes |
| public_subnet_azs | Availability Zones used for Public Subnets, has to be comma separated and same amount as subnet cidrs | - | yes |
| private_subnet_cidrs | Private Subnet CIDR Blocks to be used as comma seperated list (e.g. '10.2.x.y,10.2.z.n') | - | yes |
| private_subnet_azs | Availability Zones used for Private Subnets, has to be comma separated and same amount as subnet cidrs | - | yes |

