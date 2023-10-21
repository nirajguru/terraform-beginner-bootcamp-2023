# Terraform Beginner Bootcamp 2023
- [Terraform Beginner Bootcamp 2023](#terraform-beginner-bootcamp-2023)
  * [Terraform Basics](#terraform-basics)
    + [Terraform Providers](#terraform-providers)
    + [Terraform state file](#terraform-state-file)
    + [Terraform apply](#terraform-apply)
  * [Terraform state file in Terraform Cloud](#terraform-state-file-in-terraform-cloud)

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

## Terraform state file in Terraform Cloud
- State file in terraform cloud is automatically versioned and protected.
- Username/password shouldn't be in the state file.


## Terraform Module stucture
At a minimum, the root module should have the following structure:
 - PROJECT_ROOT
   - `main.tf`  Main config file
   - `variables.tf`  input variables
   - `outputs.tf`  stores outputs
   - `terraform.tfvars` data to be loaded in the terraform project
   - `README.md` required for root modules
 It is a good idea to add a examples folder as well.

  [Official Module structure document](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

   Complete module structure is here:   
   ```sh
      $ tree complete-module/
      .
      ├── README.md
      ├── main.tf
      ├── variables.tf
      ├── outputs.tf
      ├── ...
      ├── modules/
      │   ├── nestedA/
      │   │   ├── README.md
      │   │   ├── variables.tf
      │   │   ├── main.tf
      │   │   ├── outputs.tf
      │   ├── nestedB/
      │   ├── .../
      ├── examples/
      │   ├── exampleA/
      │   │   ├── main.tf
      │   ├── exampleB/
      │   ├── .../
```
  

