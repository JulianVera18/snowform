resource "snowflake_account_role" "role" {
  for_each = { for role in try(var.roles.account, []): role.name => role }

  name     = each.key
}
