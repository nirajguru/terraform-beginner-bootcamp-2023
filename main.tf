terraform {
  cloud {
    organization = "nirajguru"
    workspaces {
      name = "terra-house-1"
    }
  }
}

module "terrahouse" {
  source    = "./modules/terrahouse_aws"
  user_uuid = "5adb9335-897f-4472-8015-1978c71aa7ba"

}