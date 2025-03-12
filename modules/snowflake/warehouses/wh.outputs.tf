# OUTPUTS FOR **SNOWFLAKE_WAREHOUSE** RESOURCE
output "defaults" {
  value = var.defaults
}

output "warehouses" {
  description = "Mapa de warehouses creados con su nombre e id"
  value = {
    for key, wh in snowflake_warehouse.warehouse :
    key => {
      name = wh.name
      id   = wh.id
      comment = wh.comment
    }
  }
}
