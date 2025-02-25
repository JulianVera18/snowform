resource "snowflake_account_role" "role" {
  for_each = toset(keys(local.all_roles))
  name     = each.value
}
