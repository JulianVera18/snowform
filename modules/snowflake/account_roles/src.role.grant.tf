resource "snowflake_grant_account_role" "grant_to" {
  for_each = { for grant in local.grants: "${grant.parent}|${grant.child}" => grant }

  role_name        = "${var.environment}_${each.value.child}"
  parent_role_name = "${var.environment}_${each.value.parent}"

  depends_on = [snowflake_account_role.role]
}
