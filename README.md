
## Setting Terraform Remote Config (this has to be done for each folder with different keys)

`terraform remote config -backend=s3 -backend-config=region=eu-west-1 -backend-config=bucket=*S3_config_bucket* -backend-config=key=*config key* -backend-config=encrypt=true -pull=true`

## Using a Bastion Host to access instances
In this whole account setup, the idea is to use bastion hosts to access all of your instances. This means that all your instances should be in the security group "ssh_from_bastion" and only accept SSH using that security group.

To enable your machine to use a bastion host, it is easiest to change your SSH config with a rule for this.

Example:
## Bastion Host configuration for SecurityLogging account
```
Host 10.xxx.*
  ProxyCommand ssh ubuntu@<hostname_of_bastion_host> nc %h %p
```
