output "account_roles" {
  value = {
    for k, role in snowflake_account_role.role : k => {
      id = role.id
      name = role.name
    }
  }
}
