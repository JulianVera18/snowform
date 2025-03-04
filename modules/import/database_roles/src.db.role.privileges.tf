resource "snowflake_grant_privileges_to_database_role" "database_privileges" {
  for_each            = { for role, privs in local.database_privileges : "${privs.database}.${privs.role}" => privs }

  on_database         = each.value.database
  database_role_name  = "${each.value.database}.${each.value.role}"
  privileges          = each.value.privileges

  depends_on          = [
    snowflake_database_role.role,
    snowflake_grant_database_role.grants
  ]
}

resource "snowflake_grant_privileges_to_database_role" "schema_privileges" {
  for_each            = { for role, privs in local.schema_privileges : "${privs.database}.${privs.role}" => privs }

  database_role_name  = "${each.value.database}.${each.value.role}"
  privileges          = each.value.privileges

  on_schema {
    schema_name = "${each.value.database}.${each.value.schema}"
  }

  depends_on = [
    snowflake_database_role.role,
    snowflake_grant_database_role.grants,
    snowflake_grant_privileges_to_database_role.database_privileges
  ]
}
