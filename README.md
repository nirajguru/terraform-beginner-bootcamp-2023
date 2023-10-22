# Terraform Beginner Bootcamp 2023
 * [Terraform Basics](#terraform-basics)
    + [Terraform Providers](#terraform-providers)
    + [Terraform state file](#terraform-state-file)
    + [Validating input variables](#validating-input-variables)
    + [Terraform apply](#terraform-apply)
    + [Order of precedence of Terraform variables](#order-of-precedence-of-terraform-variables)
  * [Terraform Cloud](#terraform-cloud)
    + [Terraform state in Terraform Cloud](#terraform-state-in-terraform-cloud)
    + [Variables in Terraform Cloud](#variables-in-terraform-cloud)
    + [Loading Terraform Input Variables](#loading-terraform-input-variables)
  * [Terraform Module stucture](#terraform-module-stucture)
  * [Dealing with Configuration Drift](#dealing-with-configuration-drift)
    + [Manually fix the drift](#manually-fix-the-drift)
    + [Terraform import](#terraform-import)

## Terraform Basics

### Terraform Providers
Terraform providers are plugins that help Terraform talk to different platforms and cloud providers. Terraform speaks a different lanuguage. Providers help translate that into language that platforms can understand.


### Terraform state file
The state file contains information about the current state of your file.The file name is `terraform.tfstate`. This file **should not be committed** to source code repository as it might contain sensitive information.

### Validating input variables
Use the 'validation' block within the variables block

### Terraform apply
`terraform apply` will run a plan and apply the changes defined in the terraform configuration files. This command does the following:
 - reads the current state of infrastructure
 - compares the desired state of infrastructure mentioned in the config files with the current state of infrastructure
 - creates an execution plan based on the actions that will be taken to match the current state of infrastructure with the desired state of infrastructure
 - prompts the user to confirm the planned actions
 - applies the changes needed to get the desired state
 - updates terraform.tfstate with the new state
 - outputs any new information with the changes applied

### Order of precedence of Terraform variables
The order of precedence for variable sources is as follows with **LATER** sources taking precedence over earlier ones:
1. Environment variables
2. The terraform.tfvars file, if present.
3. The terraform.tfvars.json file, if present.
4. Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
5. Any -var and -var-file options on the command line, in the order they are provided.

### Built in functions
There are several built in [functions](https://developer.hashicorp.com/terraform/language/functions)
Examples: use `fileexists(path)` to check if the file exists in the specified path. This can be used in the validation of input file as below:
```sh 
  validation {
    condition = fileexists(${filepath}}"
    )
    error_message = "The file does not exist in the path"
  }
```

## Terraform Cloud
### Terraform state in Terraform Cloud
- State file in terraform cloud is automatically versioned and protected.
- Username/password shouldn't be in the state file.

### Variables in Terraform Cloud
 - *Environment Variables*: These are the variables that you would load on the command line. Example, AWS key IDs and AWS Secret key IDs
 - *Terraform Variables*: These are the variables that goes in tfvars file

### Loading Terraform Input Variables
Use `-var` flag with terraform plan or terraform apply to set an input variable or override a variable in the tfvars file. Example: `terraform plan -var user_uuid="5adb9335-897f-4472-8015-1978c71aa7ba"`


## Terraform Module stucture
At a minimum, the root module should have the following structure:
 - PROJECT_ROOT
   - `main.tf`  Main config file
   - `variables.tf`  input variables
   - `outputs.tf`  stores outputs
   - `terraform.tfvars` data to be loaded in the terraform project
   - `README.md` required for root modules.

It is a good idea to add a examples folder as well.

The modules should be placed in a `modules` subdirectory when developing locally.

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
## Dealing with Configuration Drift
### Manually fix the drift
When infrastucture is manually modified or deleted using *ClickOps*, run terraform plan to let terraform detect the drift. Apply the plan to fix the drift

### Terraform import
Run `terraform import` to import the existing infrastructure. This also lets you bring the existing resources under Terraform management.
[Terraform import documentation](https://developer.hashicorp.com/terraform/cli/import)

## Considerations when using ChatGPT or Claude AI to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation and the examples it produces may be deprecated.

## Working with files in Terraform
in Terraform there is a special variables called `path` that allows us to reference local variables.

[Special path variable documentation](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

Example, Use `${path.root}` to get the filesystem path of the root module
```sh 
resource "aws_s3_object" "index_file" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
  etag   = filemd5("${path.root}/public/index.html")
}
```

Usually it is not recommended to copy files to S3 bucket using Terraform. A configuration management or CI CD tool should be used instead. Terraform should be used to stand up the infrastructure.

