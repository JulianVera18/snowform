resource "snowflake_grant_database_role" "grants" {
  for_each                  = {for k,v in local.grants: "${v.database}.${v.child}|${v.database}.${v.parent}" => v}

  database_role_name        = "${each.value.database}.${each.value.child}"
  parent_database_role_name = "${each.value.database}.${each.value.parent}"

  depends_on                = [snowflake_database_role.role]
}
#${var.db_prefix}_${var.environment}_