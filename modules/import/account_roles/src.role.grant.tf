resource "snowflake_grant_account_role" "grant_to" {
  for_each = { for _, grant in local.account_role_grants: "${grant.role_name}|${grant.parent_role_name}" => grant }

  role_name        = each.value.role_name
  parent_role_name = each.value.parent_role_name

  depends_on = [snowflake_account_role.role]
}

resource "snowflake_grant_database_role" "grant_to" {
  for_each = { for _, grant in local.db_role_grants: "${grant.account_role}|${grant.database}.${grant.db_role}" => grant }

  database_role_name = each.value.db_role_fqn
  parent_role_name   = each.value.account_role

  depends_on = [snowflake_account_role.role]
}
