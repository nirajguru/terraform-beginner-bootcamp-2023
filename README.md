# Terraform Bootcamp 2023
  * [Terraform Basics](#terraform-basics)
    + [Terraform Providers](#terraform-providers)
    + [Terraform state file](#terraform-state-file)
    + [Validating input variables](#validating-input-variables)
    + [Terraform apply](#terraform-apply)
    + [Order of precedence of Terraform variables](#order-of-precedence-of-terraform-variables)
    + [Local Block](#local-block)
    + [Built in functions](#built-in-functions)
  * [Terraform Cloud](#terraform-cloud)
    + [Terraform state in Terraform Cloud](#terraform-state-in-terraform-cloud)
    + [Variables in Terraform Cloud](#variables-in-terraform-cloud)
    + [Loading Terraform Input Variables](#loading-terraform-input-variables)
    + [Variable Validation with Condition expression](#variable-validation-with-condition-expression)
  * [Terraform Module stucture](#terraform-module-stucture)
  * [Dealing with Configuration Drift](#dealing-with-configuration-drift)
    + [Manually fix the drift](#manually-fix-the-drift)
    + [Terraform import](#terraform-import)
  * [Considerations when using ChatGPT or Claude AI to write Terraform](#considerations-when-using-chatgpt-or-claude-ai-to-write-terraform)
  * [Working with files in Terraform](#working-with-files-in-terraform)
  * [Terraform Data Sources](#terraform-data-sources)
  * [Working with JSON](#working-with-json)
  * [Changing the lifecycle of resources](#changing-the-lifecycle-of-resources)
  * [Null resource in Terraform](#null-resource-in-terraform)

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

### Local Block
Local blocks allow you to define values that are within a module or a file but aren't available outside.
It is like a code word that only your group of friends knows. So when you say this code when you are with your friends, they know what you are talking about. But when you go outside your group, the others won't know. Similarly, the values in local block are scoped within a module or a terraform config file.
Examples:
```sh
locals{
  friends_code_word = "pineapple"
}
```

### Built in functions
There are several built in [functions](https://developer.hashicorp.com/terraform/language/functions)
Examples: use `fileexists(path)` to check if the file exists in the specified path. This can be used in the validation of input file as below:
```hcl 
  validation {
    condition = fileexists(${filepath}}"
    )
    error_message = "The file does not exist in the path"
  }
```
### Fileset()
You can use fileset() to list out all the files in a directory.
`fileset("$path.root","*")`

## Terraform Operators
[Terraform operators](https://developer.hashicorp.com/terraform/language/expressions/operators) are expressions that let you compare values, combine conditions and build logic.

```terraform
9 == 9 ? true : false
true
```

## Terraform Cloud
Terraform Cloud is the SaaS version of Terraform.
Using Terraform cloud has the advantages:
 - Manages the state file
 - Gives the ability to execute local-exec
 - Free to create account
 - Generous free tier where upto 500 resources per month can be managed
 

### Terraform state in Terraform Cloud
- State file in terraform cloud is automatically versioned and protected.
- Username/password shouldn't be in the state file.

### Variables in Terraform Cloud
 - *Environment Variables*: These are the variables that you would load on the command line. Example, AWS key IDs and AWS Secret key IDs
 - *Terraform Variables*: These are the variables that goes in tfvars file

### Loading Terraform Input Variables
Use `-var` flag with terraform plan or terraform apply to set an input variable or override a variable in the tfvars file. Example: `terraform plan -var user_uuid="5adb9335-897f-4472-8015-1978c71aa7ba"`

### Variable Validation with Condition expression
The input variables can be validated by using the `condition` expression.
[Variable Validation](https://dev.to/pwd9000/terraform-variable-validation-47ka#:~:text=Understanding%20Terraform%20Variable%20Validation&text=There%20are%20two%20key%20components,condition%20is%20a%20boolean%20expression.)
Example code here that checks variable content_version is a positive integer
```hcl
variable "content_version" {
  type = number
  validation {
    condition     = var.content_version > 0 && floor(var.content_version) == var.content_version
    error_message = "The content_version value must be a positive integer."
  }
 }
```

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
```hcl 
resource "aws_s3_object" "index_file" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
  etag   = filemd5("${path.root}/public/index.html")
}
```

Usually it is not recommended to copy files to S3 bucket using Terraform. A configuration management or CI CD tool should be used instead. Terraform should be used to stand up the infrastructure.

## Terraform Data Sources
Terraform data sources allow you to lookup information of the resources that are not directly managed by Terraform. Example, you can get the available AMIs within an account.

Data source is called within a `data` block. Below code will get the account number:
```hcl
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
} 
```

## Working with JSON
We use `jsonencode()` for creating IAM policy in json format inline in the Terraform config file.
```hcl
jsonencode({"name"="niraj"})
{"name":"niraj"}
```
[jsonencode documentation](https://developer.hashicorp.com/terraform/language/functions/jsonencode)
It is important to note that equal sign in hcl is replaced by : in json.

## Changing the lifecycle of resources
[Lifecycle meta-arguments](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle) describes the general lifecycle of resources.
Available lifecycle arguments:
- `create_before_destroy`
- `prevent_destroy`
- `ignore_changes` e.g. you added tags and you don't want the resource to be updated
- `replace_triggered_by`


## Null resource in Terraform
Null resource is now **DEPRECATED** by `terraform_data`.

You would use `null` resource when you don't want Terraform to create or update any real infrastrcture but you want some custom actions in the middle of Terraform flow. For example,
- Run a script that sets up some variables required later
- Add delays before the next step runs
- To trigger when some external resource gets updated
- To run a provisioning tool like Ansible on your servers

## Provisioners
Provisioners allow to execute commands on VMs e.g. AWS CLI Command.
This is usually not recommended as Terraform should be used to manage the Infrastructure. The configuration management should be done by configuration management tools like Ansible, Puppet, Chef, etc.
Provisioners should be used as a last resort.

### Local-exec

This will execute command on the machine running Terraform commands.

### Remote-exec

This will execute command on the target machines. We need to provide credentials/ssh authentication to login to machine.
One of the use case can be copying files from local machines running Terraform to the remote machine (can be provisioned by Terraform)

## For each meta argument
For each allows us to iterate over different data types. This is useful when there are multiple resources are required.
[For each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
For lists, `each.key` is sufficient to iterate. For Maps, both `each.key` and `each.value` are required.