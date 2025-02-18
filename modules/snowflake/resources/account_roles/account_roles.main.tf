locals {
  role_grants = merge([
    for role_name, role in var.account_roles :
    {
      for parent_role in try(role.grant_to.roles, []) : "${role_name}|${parent_role}" => {
        role_name = role_name
        parent_role = parent_role
      }
    }
  ]...)
}

resource "snowflake_account_role" "role" {
  for_each = var.account_roles
  name     = each.key
}

resource "snowflake_grant_account_role" "grant_to" {
  for_each = local.role_grants

  role_name = snowflake_account_role.role[each.value.role_name].name
  parent_role_name = each.value.parent_role
}
