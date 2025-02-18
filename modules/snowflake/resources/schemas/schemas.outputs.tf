output "schemas" {
  value = { for k,v in snowflake_schema.schemas : k => v }
}

output "fqn" {
  value = [
    for schema in snowflake_schema.schemas : {
      database             = schema.database
      schema               = schema.name
      fully_qualified_name = "${schema.database}.${schema.name}"
      dbrole_prefix        = "${schema.database}_${schema.name}"
    }
  ]
}
