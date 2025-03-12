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
  all_roles      = try(var.roles.database, {})
  all_privileges = try(var.privileges, {})

  all_database_roles = try(flatten([
    for schema in var.schemas: [
      for role_name in keys(local.all_roles): {
        database = "${var.db_prefix}_${var.environment}_${schema.database}"
        role     = "${var.sc_prefix}_${schema.name}_${role_name}"
      }
    ]
  ]), [])

  grants  = try(flatten([
    for schema in var.schemas: flatten([
      for role, childs in transpose(local.all_roles): [
        for child in childs: {
          database = "${var.db_prefix}_${var.environment}_${schema.database}"
          parent = "${var.sc_prefix}_${schema.name}_${role}"
          child  = "${var.sc_prefix}_${schema.name}_${child}"
        }
      ]
    ])
  ]), [])

  database_privileges = try(flatten([
    for schema in var.schemas: flatten([
      for role_name, privs in transpose(local.all_privileges.database): {
        database = "${var.db_prefix}_${var.environment}_${schema.database}"
        role = "${var.sc_prefix}_${schema.name}_${role_name}"
        privileges = privs
      }
    ])
  ]), [])

  schema_privileges = try(flatten([
    for schema in var.schemas: flatten([
      for role_name, privs in transpose(local.all_privileges.schema): {
        database = "${var.db_prefix}_${var.environment}_${schema.database}"
        schema = "${var.sc_prefix}_${schema.name}"
        role = "${var.sc_prefix}_${schema.name}_${role_name}"
        privileges = privs
      }
    ])
  ]), [])
}
