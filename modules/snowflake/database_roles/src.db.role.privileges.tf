resource "snowflake_grant_privileges_to_database_role" "database_privileges" {
  for_each = { for role,privs in local.database_privileges : "${privs.database}.${privs.role}" => privs }

  on_database         = each.value.database
  database_role_name  = "${each.value.database}.${each.value.role}"
  privileges          = each.value.privileges

  depends_on = [
    snowflake_database_role.role,
    snowflake_grant_database_role.grants
  ]
}

resource "snowflake_grant_privileges_to_database_role" "schema_privileges" {
  for_each = { for role,privs in local.schema_privileges : "${privs.database}.${privs.role}" => privs }

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

resource "snowflake_grant_privileges_to_database_role" "on_all_privileges" {
  for_each = { for _,privs in local.future_object_privileges : "${privs.database}.${privs.role}.${privs.object_type}" => privs }

  database_role_name  = "${each.value.database}.${each.value.role}"
  privileges          = each.value.privileges

  on_schema_object {
    all {
      object_type_plural = upper(each.value.object_type)
      in_schema          = "${each.value.database}.${each.value.schema}"
    }
  }

  depends_on = [
    snowflake_database_role.role,
    snowflake_grant_database_role.grants,
    snowflake_grant_privileges_to_database_role.database_privileges,
    snowflake_grant_privileges_to_database_role.schema_privileges
  ]
}

resource "snowflake_grant_privileges_to_database_role" "future_privileges" {
  for_each = { for _,privs in local.future_object_privileges : "${privs.database}.${privs.role}.${privs.object_type}" => privs }

  database_role_name  = "${each.value.database}.${each.value.role}"
  privileges          = each.value.privileges

  on_schema_object {
    future {
      object_type_plural = upper(each.value.object_type)
      in_schema          = "${each.value.database}.${each.value.schema}"
    }
  }

  depends_on = [
    snowflake_database_role.role,
    snowflake_grant_database_role.grants,
    snowflake_grant_privileges_to_database_role.database_privileges,
    snowflake_grant_privileges_to_database_role.schema_privileges,
    snowflake_grant_privileges_to_database_role.on_all_privileges
  ]
}
