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
  # LOCAL - snowflake resources
  # ----------------------------------------------------
  resource_files = try(fileset(var.paths.resources, "*.yaml"), [])

  yaml_to_resources = {
    for yml in local.resource_files :
      basename(yml) => yamldecode(file("${var.paths.resources}/${yml}"))
  }

  resources = merge([
    for content in values(local.yaml_to_resources):
      try(content.snowflake.resources, {})
  ]...)

  warehouses     = try(local.resources.warehouses, [])
  databases      = try(local.resources.databases, [])
  # service_users  = try(local.resources.service_users, [])




  # LOCAL - snowflake resource default parameters
  # ----------------------------------------------------
  defaults          = try(yamldecode(file("${var.paths.defaults}/defaults.yaml")).snowflake.resources, [])




  # LOCAL - snowflake rbac files account roles && database roles
  # ----------------------------------------------------
  role_file      = try(fileset(var.paths.roles, "*.yaml"), [])

  account_role_yaml = try(yamldecode(file("${var.paths.roles}/account.role.yaml")), {})
  dbrole_yaml       = try(yamldecode(file("${var.paths.roles}/db.role.yaml")), {})
  dbrole_db_schema  = flatten([
    for db in local.databases: [
      for schema in try(db.schemas, []): {
        database = db.name
        name     = schema.name
      }
    ]
  ])



  # LOCAL - datamarts template-driven
  # ----------------------------------------------------
  templates = merge([
    for content in values(local.yaml_to_resources):
      try(content.snowflake.templates, {})
  ]...)

}

module "warehouse" {
  warehouses      = local.warehouses
  source          = "./warehouses"
  naming          = var.naming

  #nomenclatura
  environment     = var.environment
  wh_prefix       = var.wh_prefix

  # ownership_role = join("", lookup(module.account_role.locals.ownership_roles, var.environment, ["TERRAFORM_ADMIN"]))
  defaults        = local.defaults.warehouses
}

module "database" {
  source          = "./databases"
  databases       = local.databases
  #nomenclatura
  environment     = var.environment
  db_prefix       = var.db_prefix

  # ownership_role = join("", lookup(module.account_role.locals.ownership_roles, var.environment, ["TERRAFORM_ADMIN"]))
  defaults        = local.defaults.databases
}

module "schema" {
  source          = "./schemas"
  databases       = local.databases

  #nomenclatura
  environment     = var.environment
  db_prefix       = var.db_prefix
  sc_prefix       = var.sc_prefix

  #  ownership_role = join("", lookup(module.account_role.locals.ownership_roles, var.environment, ["TERRAFORM_ADMIN"]))
  depends_on      = [ module.database ]
}

module "database_role" {
  source          = "./database_roles"
  roles           = var.deploy.resources.database_roles ? local.dbrole_yaml.roles : null
  privileges      = var.deploy.resources.database_roles ? local.dbrole_yaml.privileges : null
  schemas         = var.deploy.resources.database_roles ? local.dbrole_db_schema : null

  #nomenclatura
  environment     = var.environment
  db_prefix       = var.db_prefix
  sc_prefix       = var.sc_prefix
  depends_on      = [ module.database, module.schema ]
}

module "account_role" {
  source                   = "./account_roles"
  
  roles                    = var.deploy.resources.account_roles ? local.account_role_yaml.roles : null
  privileges               = var.deploy.resources.account_roles ? local.account_role_yaml.privileges : null
  #nomenclatura
  environment              = var.environment
  db_prefix                = var.db_prefix
  wh_prefix                = var.wh_prefix
  depends_on      = [
    module.warehouse,
    module.database,
    module.schema,
    module.database_role
  ]
}

module "transfer_ownership" {
  source         = "./transfer_ownership"

  ownership_role = module.account_role.locals.ownership_role
  environment    = var.environment
  wh_prefix      = var.wh_prefix
  db_prefix      = var.db_prefix
  sc_prefix      = var.sc_prefix

  warehouses = module.warehouse.warehouses
  databases  = module.database.databases
  schemas    = module.schema.schemas

  depends_on = [
    module.account_role,
    module.warehouse,
    module.database,
    module.schema
  ]
}

