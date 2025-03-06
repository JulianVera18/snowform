resource "snowflake_grant_ownership" "transfer_warehouse_ownership" {
  for_each = { for wh in var.warehouses : "${var.wh_prefix}_${wh.name}_${var.environment}" => wh }

  account_role_name = var.ownership_role 
  on {
    object_type = "WAREHOUSE"
    object_name = each.key
  }
}
