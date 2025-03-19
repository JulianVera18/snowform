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

# Account level privileges
resource "snowflake_grant_privileges_to_account_role" "account_level" {
  for_each = { for i, grant in local.account_level_privileges: "${grant.role_name}" => grant }

  account_role_name = each.value.role_name
  privileges        = each.value.privileges
  on_account        = true
  with_grant_option = try(each.value.with_grant_option, false)

  depends_on = [snowflake_account_role.role]
}

# Account object privileges
resource "snowflake_grant_privileges_to_account_role" "account_object" {
  for_each = { for i, grant in local.account_object_privileges: "${grant.role_name}" => grant }

  account_role_name = each.value.role_name
  privileges        = each.value.privileges
  on_account_object {
    object_type = each.value.on_account_object.object_type
    object_name = each.value.on_account_object.object_name
  }
  with_grant_option = try(each.value.with_grant_option, false)

  depends_on = [snowflake_account_role.role]
}

# Schema privileges
resource "snowflake_grant_privileges_to_account_role" "schema" {
  for_each = { for i, grant in local.schema_privileges: grant.role_name => grant }

  account_role_name = each.value.role_name
  privileges        = each.value.privileges
  on_schema {
    schema_name               = try(each.value.on_schema.schema_name, null)
    all_schemas_in_database   = try(each.value.on_schema.all_schemas_in_database, null)
    future_schemas_in_database = try(each.value.on_schema.future_schemas_in_database, null)
  }
  with_grant_option = try(each.value.with_grant_option, false)

  depends_on = [snowflake_account_role.role]
}

# Schema object privileges - specific objects
resource "snowflake_grant_privileges_to_account_role" "schema_object_specific" {
  for_each = { for i, grant in local.schema_object_specific: grant.role_name => grant }

  account_role_name = each.value.role_name
  privileges        = each.value.privileges
  on_schema_object {
    object_type = each.value.on_schema_object.object_type
    object_name = each.value.on_schema_object.object_name
  }
  with_grant_option = try(each.value.with_grant_option, false)

  depends_on = [snowflake_account_role.role]
}

# Schema object privileges - all objects
resource "snowflake_grant_privileges_to_account_role" "schema_object_all" {
  # for_each = { for i, grant in local.schema_object_all: grant.role_name => grant }
  # for_each = { for i, grant in local.schema_object_all: "${grant.role_name}-${i}" => grant }
  for_each = {
    for grant in local.schema_object_all : 
    "${grant.role_name}-${grant.on_schema_object.all.in_schema}-${grant.on_schema_object.all.object_type_plural}" => grant
  }

  account_role_name = each.value.role_name
  privileges        = each.value.privileges
  on_schema_object {
    all {
      object_type_plural = each.value.on_schema_object.all.object_type_plural
      in_database        = try(each.value.on_schema_object.all.in_database, null)
      in_schema          = try(each.value.on_schema_object.all.in_schema, null)
    }
  }
  with_grant_option = try(each.value.with_grant_option, false)

  depends_on = [snowflake_account_role.role]
}

# Schema object privileges - future objects
resource "snowflake_grant_privileges_to_account_role" "schema_object_future" {
  # for_each = { for i, grant in local.schema_object_future: grant.role_name => grant }
  for_each = {
    for grant in local.schema_object_all : 
    "${grant.role_name}-${grant.on_schema_object.all.in_schema}-${grant.on_schema_object.all.object_type_plural}" => grant
  }

  account_role_name = each.value.role_name
  privileges        = each.value.privileges
  on_schema_object {
    future {
      object_type_plural = each.value.on_schema_object.future.object_type_plural
      in_database        = try(each.value.on_schema_object.future.in_database, null)
      in_schema          = try(each.value.on_schema_object.future.in_schema, null)
    }
  }
  with_grant_option = try(each.value.with_grant_option, false)

  depends_on = [snowflake_account_role.role]
}
