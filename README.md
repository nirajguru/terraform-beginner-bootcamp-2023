# Terraform Beginner Bootcamp 2023

## Terraform Basics

### Terraform Providers
Terraform providers are plugins that help Terraform talk to different platforms and cloud providers. Terraform speaks a different lanuguage. Providers help translate that into language that platforms can understand.


### Terraform state file
The state file contains information about the current state of your file.The file name is `terraform.tfstate`. This file **should not be committed** to source code repository as it might contain sensitive information.

### Terraform apply
`terraform apply` will run a plan and apply the changes defined in the terraform configuration files. This command does the following:
 - reads the current state of infrastructure
 - compares the desired state of infrastructure mentioned in the config files with the current state of infrastructure
 - creates an execution plan based on the actions that will be taken to match the current state of infrastructure with the desired state of infrastructure
 - prompts the user to confirm the planned actions
 - applies the changes needed to get the desired state
 - updates terraform.tfstate with the new state
 - outputs any new information with the changes applied



