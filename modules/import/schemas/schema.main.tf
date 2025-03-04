terraform {
  required_version = ">= 1.7.4"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
    }
  }
}

locals {
  schemas = try(flatten([
    for db in var.databases: [
    for schema in lookup(db, "schemas"):
      merge(schema, { "database" = db.name })
    ]
  ]), [])
}
