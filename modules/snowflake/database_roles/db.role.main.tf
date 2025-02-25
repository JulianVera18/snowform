terraform {
  required_version = ">= 1.7.4"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
    }
  }
}

locals {

  # database roles (from templates)
  # ------------------------
  all_roles      = try(var.dbroles.roles, {})
  all_privileges = try(var.dbroles.privileges, {})

  all_database_roles = flatten([
    for schema in var.schemas: [
      for role_name in keys(local.all_roles): {
        database = schema.database
        role     = "${schema.name}_${role_name}"

      }
    ]
  ])

  grants  = flatten([
    for schema in var.schemas: flatten([
      for role, childs in transpose(local.all_roles): [
        for child in childs: {
          database = schema.database
          parent = "${schema.name}_${role}"
          child  = "${schema.name}_${child}"
        }
      ]
    ])
  ])

  database_privileges = flatten([
    for schema in var.schemas: flatten([
      for role_name, privs in transpose(local.all_privileges.database): {
        role = "${schema.name}_${role_name}"
        privileges = privs
        database = schema.database
      }
    ])
  ])

  schema_privileges = flatten([
    for schema in var.schemas: flatten([
      for role_name, privs in transpose(local.all_privileges.schema): {
        role = "${schema.name}_${role_name}"
        privileges = privs
        database = schema.database
        schema = schema.name
      }
    ])
  ])
}

