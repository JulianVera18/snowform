resource "snowflake_database_role" "role" {
  for_each   = { for role in local.all_database_roles : "${role.database}.${role.role}" => role }

  name       = each.value.role
  database   = each.value.database
}


output "locals" {
  value = {
    all_roles          = local.all_roles
    all_database_roles = local.all_database_roles
    grants             = local.grants
    privileges     = {
      database = local.database_privileges
      schema   = local.schema_privileges
    }
  }
}

