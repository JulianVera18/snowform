terraform {
  required_version = ">= 1.7.4"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = ">= 0.98.0, < 1.0.0"
    }
  }
}

locals {
  # ----------------------------------------------------
  # resource_files    | resource definition files path
  # roles_files       | templates files path
  # yaml_to_resources | merge all snowflake resources
  # resources         | all resources available as variables
  # ----------------------------------------------------
  resource_files = fileset(var.paths.resources, "*.yaml")
  role_files     = var.deploy.resources.database_roles ? fileset(var.paths.roles, "*.yaml") : []

  yaml_to_resources = {
    for yml in local.resource_files :
      basename(yml) => yamldecode(file("${var.paths.resources}/${yml}"))
  }

  resources = merge([
    for content in values(local.yaml_to_resources): 
      try(content.snowflake.resources, {})
  ]...)

  warehouses = try(local.resources.warehouses, [])
  databases  = try(local.resources.databases, [])

  # ----------------------------------------------------
  # roles         | rbac roles
  # dbroles       | defines database roles
  # account_roles | defines account roles
  # ----------------------------------------------------
  roles = try({
    for rbac in local.role_files :
      basename(rbac) => yamldecode(file("${var.paths.roles}/${rbac}"))
  }, {})

  dbroles       = try(local.roles["db.role.yaml"], {})
  # account_roles = try(local.roles["account.role.yaml"], {})
}

 module "warehouse" {
   source          = "./warehouses"
   warehouses      = local.warehouses
 }

 module "database" {
   source          = "./databases"
   databases       = local.databases
 }

 module "schema" {
   source          = "./schemas"
   databases       = local.databases
   depends_on      = [ module.database ]
 }

 module "database_role" {
   source          = "./database_roles"

   dbroles         = local.dbroles
   schemas         = var.deploy.resources.database_roles ? module.database.schemas : []
   depends_on      = [ module.database, module.schema ]
 }

 module "account_role" {
   source                   = "./account_roles"
   workspace                = var.deploy.resources.account_roles ? var.workspace : ""
   depends_on               = [ module.warehouse, module.database ]
 }
