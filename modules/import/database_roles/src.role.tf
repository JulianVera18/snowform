resource "snowflake_database_role" "role" {
  for_each   = { for role in local.all_database_roles : "${role.database}.${role.role}" => role }

  name       = each.value.role
  database   = each.value.database
}

