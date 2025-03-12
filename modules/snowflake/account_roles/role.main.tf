terraform {
  required_version = ">= 1.7.4"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
    }
  }
}

locals {
  account_role_grants = try(flatten([
    for role in var.roles.account: [
      for parent_role in try(role.account, []): {
        role_name = role.name
        parent_role_name = parent_role
      }
    ]
  ]), [])

  db_role_grants = try(flatten([
    for role in var.roles.account: [
      for db_name, db_roles in try(role.database, {}): [
        for db_role in db_roles: {
          account_role = role.name
          database     = db_name
          db_role      = db_role
          db_role_fqn  = "\"${db_name}\".\"${db_role}\""
        }
      ]
    ]
  ]), [])


  system_role_grants = try(flatten([
    for role in var.roles.system_role: [
      for parent_role in try(role.account, []): {
        role_name = role.name
        parent_role_name = parent_role
      }
    ]
  ]), [])

  ownership_role = element(lookup(var.roles.ownership_roles, var.environment, []), 0)

}