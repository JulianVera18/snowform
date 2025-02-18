locals {
  yamls = {
    for file in fileset(path.root, "${var.configs.paths.resources}/*.yaml") :
      file => yamldecode(file(file))
  }

  resources     = merge([ for content in local.yamls : try(content.snowflake.resources, {})]...)
  account_roles = try(local.resources.account_roles, {})
  warehouses    = try(local.resources.warehouses, {})
  databases     = try(local.resources.databases, {})
}

module "warehouses" {
  source          = "./resources/warehouses"
  warehouses      = local.warehouses
}

module "databases" {
  source          = "./resources/databases"
  databases       = local.databases
}

module "schemas" {
  source          = "./resources/schemas"
  schemas         = local.databases
  depends_on      = [module.databases]
}

module "database_roles" {
  source          = "./resources/database_roles"
  schemas_fqn     = module.schemas.fqn

  # replace input files to fileset() function
  privileges_file = "${var.configs.paths.templates}/privileges.yaml"
  hierarchy_file  = "${var.configs.paths.templates}/hierarchy.yaml"

  depends_on      = [module.databases, module.schemas]
}

module "account_roles" {
  source          = "./resources/account_roles"
  account_roles   = local.account_roles

  depends_on      = [module.warehouses, module.databases, module.schemas]
}


