# account-setup-basics

## Manual Steps right now:
1. creating switch role from main account to new account
2. Set Terraform Remote Config
3. Giving cross account S3 Bucket access to hope.comoyo.com

## General Workflow
The idea behind this repository is to have a default blueprint for an account structure. It provides basic terraform files and tools to make setting this up as seamless as possible without sacrificing too much flexibility.
Applying the terraform configuration to your account happens by assuming a role in your target account using your regular user from the main account. When assuming a role, one will be given a security token that is valid for one hour, after that period of time, the role has to be assumed again.

To achieve this, run the following command in the root folder of this repo:

`source ./aws_creds.sh <your ARN for switching roles, e.g. arn:aws:iam::05146135148:role/myCrossAcountAdmin>`


## Creating Switch Role Access
Follow the guide on https://aws.amazon.com/blogs/aws/new-cross-account-access-in-the-aws-management-console/

## Setting Terraform Remote Config (this has to be done for each folder with different keys)

`terraform remote config -backend=s3 -backend-config=region=eu-west-1 -backend-config=bucket=*S3_config_bucket* -backend-config=key=*config key* -backend-config=encrypt=true -pull=true`

## Cross account Access to hope.comoyo.com
This step is required for the GS-AMI to be able to update SSH keys in the authorized keys list of its ssh config. Without this, it will be possible to start an instance, but accessing it will be impossible.

Just add the following snippet at the right location in the S3 Bucket configuration of hope.comoyo.com:
```
		{
			"Sid": "Stmt1424694126992",
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::<new_account_id>:root"
			},
			"Action": [
				"s3:ListBucket",
				"s3:GetBucketLocation"
			],
			"Resource": "arn:aws:s3:::hope.comoyo.com"
		},
		{
			"Sid": "Stmt1424694126993",
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::<new_account_id>:root"
			},
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::hope.comoyo.com/user/*"
		}
```

## Using a Bastion Host to access instances
In this whole account setup, the idea is to use bastion hosts to access all of your instances. This means that all your instances should be in the security group "ssh_from_bastion" and only accept SSH using that security group.

To enable your machine to use a bastion host, it is easiest to change your SSH config with a rule for this.

Example:
## Bastion Host configuration for SecurityLogging account
```
Host 10.xxx.*
  ProxyCommand ssh comoyo@<hostname_of_bastion_host> nc %h %p
```

## Consul & Prometheus Terraform Configuration Folders
The terraform configuration in the folders 'terraform/eu-west-1/consul-server' and 'terraform/eu-west-1/prometheus' are not necessary for many new account setups. They are aimed at Digital Global Services AWS accounts that want to be included in global service discovery and global metrics collection. If this is not required for the new account they can be safely ignored.
