# databases
import {
  for_each = {
    for resource in local.imports :
    resource.id => resource if resource.type == "database"
  }

  id = each.value.id
  to = module.snowflake.module.database.snowflake_database.database[each.value.to]
}

# schemas
import {
  for_each = toset(flatten([
    for resource in local.imports :
    resource.schemas
    if resource.type == "schema"
  ]))

  id = each.value
  to = module.snowflake.module.schema.snowflake_schema.schema[each.value]
}

# warehouses
import {
  for_each = toset(flatten([
    for resource in local.imports :
    resource.warehouses
    if resource.type == "warehouse"
  ]))

  id = each.value
  to = module.snowflake.module.warehouse.snowflake_warehouse.warehouse[each.value]
}

