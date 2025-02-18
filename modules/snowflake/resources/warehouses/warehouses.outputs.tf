output "warehouses" {
  value = { for k,v in snowflake_warehouse.warehouse[*] : k => v }
}
