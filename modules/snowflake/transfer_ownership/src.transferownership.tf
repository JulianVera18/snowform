resource "snowflake_grant_ownership" "transfer_warehouse_ownership" {
  for_each = { for key, wh in var.warehouses : key => wh }

  account_role_name = var.ownership_role
  on {
    object_type = "WAREHOUSE"
    object_name = each.value.name
  }
}

resource "snowflake_grant_ownership" "transfer_database_ownership" {
  for_each = { for key, db in var.databases : key => db }

  account_role_name = var.ownership_role
  outbound_privileges = "COPY"
  on {
    object_type = "DATABASE"
    object_name = each.value.name
  }
}

resource "snowflake_grant_ownership" "transfer_schema_ownership" {
  for_each = { for key, sch in var.schemas : key => sch }

  account_role_name = var.ownership_role
  outbound_privileges = "COPY"
  on {
    object_type = "SCHEMA"
    object_name = "${each.value.database}.${each.value.name}"
  }
}