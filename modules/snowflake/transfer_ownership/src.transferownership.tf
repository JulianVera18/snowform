resource "snowflake_grant_ownership" "transfer_warehouse_ownership" {
  for_each = { for key, wh in try(var.warehouses, []) : key => wh }

  account_role_name = try(var.ownership_role, [])
  outbound_privileges = "COPY"
  on {
    object_type = "WAREHOUSE"
    object_name = each.value.name
  }
}

resource "snowflake_grant_ownership" "transfer_database_ownership" {
  for_each = { for key, db in try(var.databases, []) : key => db }

  account_role_name = try(var.ownership_role, [])
  outbound_privileges = "COPY"
  on {
    object_type = "DATABASE"
    object_name = each.value.name
  }
}

resource "snowflake_grant_ownership" "transfer_schema_ownership" {
  for_each = { for key, sch in try(var.schemas, []) : key => sch }

  account_role_name = try(var.ownership_role, [])
  outbound_privileges = "COPY"
  on {
    object_type = "SCHEMA"
    object_name = "${each.value.database}.${each.value.name}"
  }
}

resource "snowflake_grant_ownership" "transfer_schema_tables" {
  for_each = { for key, sch in try(var.schemas, []) : key => sch }

  account_role_name   = try(var.ownership_role, [])
  outbound_privileges = "COPY"
  on {
    all {
      object_type_plural = "TABLES"
      in_schema          = "\"${each.value.database}\".\"${each.value.name}\""
    }
  }
}

resource "snowflake_grant_ownership" "transfer_schema_views" {
  for_each = { for key, sch in try(var.schemas, []) : key => sch }

  account_role_name   = try(var.ownership_role, [])
  outbound_privileges = "COPY"
  on {
    all {
      object_type_plural = "VIEWS"
      in_schema          = "\"${each.value.database}\".\"${each.value.name}\""
    }
  }
}

resource "snowflake_grant_ownership" "transfer_schema_stages" {
  for_each = { for key, sch in try(var.schemas, []) : key => sch }

  account_role_name   = try(var.ownership_role, [])
  outbound_privileges = "COPY"
  on {
    all {
      object_type_plural = "STAGES"
      in_schema          = "\"${each.value.database}\".\"${each.value.name}\""
    }
  }
}

resource "snowflake_grant_ownership" "transfer_schema_ff" {
  for_each = { for key, sch in try(var.schemas, []) : key => sch }

  account_role_name   = try(var.ownership_role, [])
  outbound_privileges = "COPY"
  on {
    all {
      object_type_plural = "FILE FORMATS"
      in_schema          = "\"${each.value.database}\".\"${each.value.name}\""
    }
  }
}

resource "snowflake_grant_ownership" "transfer_schema_procedures" {
  for_each = { for key, sch in try(var.schemas, []) : key => sch }

  account_role_name   = try(var.ownership_role, [])
  outbound_privileges = "COPY"
  on {
    all {
      object_type_plural = "PROCEDURES"
      in_schema          = "\"${each.value.database}\".\"${each.value.name}\""
    }
  }
}