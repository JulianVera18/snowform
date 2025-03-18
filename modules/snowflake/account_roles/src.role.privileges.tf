resource "snowflake_grant_privileges_to_account_role" "warehouse_privileges" {
  for_each = {
    for wp in local.warehouse_privileges :
    "${wp.warehouse_name}.${wp.role}.${wp.privilege}" => wp
  }

  # Otorga el privilegio (en una lista) al role indicado
  privileges        = [each.value.privilege]
  account_role_name = each.value.role

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = each.value.warehouse_name
  }

  depends_on = [snowflake_account_role.role]
}
