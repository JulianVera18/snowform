terraform {
  required_version = ">= 1.7.4"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = ">= 0.98.0, < 1.0.0"
    }
  }
}

provider "snowflake" {}

locals {}

module "snowflake" {
  source          = "./modules/snowflake"

  # environment configs
  team            = var.configs.team
  tags            = var.configs.tags

  # resources configs
  configs         = var.configs
}

