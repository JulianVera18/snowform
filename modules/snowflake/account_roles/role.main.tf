terraform {
  required_version = ">= 1.7.4"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
    }
  }
}

locals {
  account_roles = try(var.roles.account, [])

  account_role_grants = try(flatten([
    for role, parent_roles in transpose({ for role in var.roles.account : role.name => try(role.account, []) }): [
      for parent_role in parent_roles : {
        role_name        = role
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
  for role, parent_roles in transpose({ for role in var.roles.system_role : role.name => try(role.account, []) }): [
    for parent_role in parent_roles : {
      role_name        = role
      parent_role_name = parent_role
    }
  ]
]), [])


  warehouse_privileges = flatten([
    for wh, priv_map in try(var.privileges.warehouse, []) : [
      for priv, roles in priv_map : [
        for role in roles : {
          # Construir el nombre completo del warehouse usando la convención
          warehouse_name = "${wh}"
          privilege      = priv
          role           = role
        }
      ]
    ]
  ])

  ownership_role = try(element(lookup(var.roles.ownership_roles, var.environment, []), 0), [])
  
  all_privileges = flatten([
    for role in local.account_roles : [
      for privilege in try(role.privileges, []) : merge(privilege, { role_name = role.name })
    ]
  ])
  account_level_privileges = [for p in local.all_privileges : p if p.type == "account_level"]
  account_object_privileges = [for p in local.all_privileges : p if p.type == "account_object"]
  schema_privileges = [for p in local.all_privileges : p if p.type == "schema"]
  
  schema_object_specific = [for p in local.all_privileges : p if p.type == "schema_object" && try(p.on_schema_object.object_type, null) != null]
  schema_object_all = [for p in local.all_privileges : p if p.type == "schema_object" && try(p.on_schema_object.all, null) != null]
  schema_object_future = [for p in local.all_privileges : p if p.type == "schema_object" && try(p.on_schema_object.future, null) != null]

}