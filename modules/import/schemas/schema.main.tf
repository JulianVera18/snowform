terraform {
  required_version = ">= 1.7.4"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
    }
  }
}

locals {
  schemas = flatten([
    for db in var.databases: [
      for schema in try(db.schemas, []): {
        database = db.name
        name = schema.name
      }
    ]
  ])
}

output "local_schemas" {
  value = local.schemas
}

output "var_databases" {
  value = var.databases
}
