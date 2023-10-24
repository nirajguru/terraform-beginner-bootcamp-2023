terraform {
  cloud {
    organization = "nirajguru"
    workspaces {
      name = "terra-house-1"
    }
  }
}

module "terrahouse" {
  source          = "./modules/terrahouse_aws"
  user_uuid       = var.user_uuid
  content_version = var.content_version
}
