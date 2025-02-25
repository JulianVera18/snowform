terraform {
  required_version = ">= 1.7.4"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = ">= 0.98.0, < 1.0.0"
    }
  }
}

provider "snowflake" {
  organization_name      = "VUWIMQM"
  account_name           = "JCA77957"
  user                   = "TERRAFORM"
  authenticator          = "JWT"
  private_key            = file("C:/Users/Seidor/Downloads/snowform-main/rsa_key.p8")
}

locals {
  # hardcoded
  environment = "dev"
  ws          = "security"

  yaml        = yamldecode(file("${local.environment}.snowflake.yaml"))
  workspace   = coalesce(local.ws, terraform.workspace)
  env         = coalesce(local.environment, local.yaml.config.environment)

  imports = try(yamldecode(file("${var.import_path}")).resources, {})
}

module "snowflake" {
  source = "./modules/snowflake"

  # Snowflake configurations
  environment = local.env
  workspace   = local.workspace
  paths = {
    resources = format(local.yaml.config.paths.resources, local.env, local.workspace)
    roles     = format(local.yaml.config.paths.roles,     local.env, local.workspace)
    defaults  = format(local.yaml.config.paths.defaults,  local.env, local.workspace)
  }
  deploy = local.yaml.config.deploy
  naming = local.yaml.config.naming
}
