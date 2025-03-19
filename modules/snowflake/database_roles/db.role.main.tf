terraform {
  required_version = ">= 1.7.4"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
    }
  }
}

locals {
  all_roles = {
    for sch in var.schemas:
    "${sch.database}.${sch.name}" =>
      yamldecode(templatefile("${var.template_path}/roles/${var.template_name}.yaml.tftpl", {
        schema = upper(sch.name)
      }))
  }

  all_database_roles = try(flatten([
    for sch in var.schemas: [
      for role_name in keys(local.all_roles["${sch.database}.${sch.name}"].roles.database): {
        database = sch.database
        role     = "${var.sc_prefix}_${role_name}"
      }
    ]
  ]), [])

  grants = try(flatten([
    for sch in var.schemas: flatten([
      for role, childs in local.all_roles["${sch.database}.${sch.name}"].roles.database: [
        for child in childs: {
          database = "${var.db_prefix}_${var.environment}_${sch.database}"
          parent   = "${var.sc_prefix}_${role}"
          child    = "${var.sc_prefix}_${child}"
        }
      ]
    ])
  ]), [])

  database_privileges = try(flatten([
    for sch in var.schemas: flatten([
      for role_name, privs in transpose(local.all_roles["${sch.database}.${sch.name}"].privileges.database): {
        database   = "${var.db_prefix}_${var.environment}_${sch.database}"
        role       = "${var.sc_prefix}_${role_name}"
        privileges = privs
      }
    ])
  ]), [])

  schema_privileges = try(flatten([
    for sch in var.schemas: flatten([
      for role_name, privs in transpose(local.all_roles["${sch.database}.${sch.name}"].privileges.schema): {
        database   = "${var.db_prefix}_${var.environment}_${sch.database}"
        schema     = "${var.sc_prefix}_${sch.name}"
        role       = "${var.sc_prefix}_${role_name}"
        privileges = privs
      }
    ])
  ]), [])

  all_privileges = {
    for sch in var.schemas:
    "${sch.database}.${sch.name}" =>
      yamldecode(templatefile("${var.template_path}/roles/${var.template_name}.yaml.tftpl", {
        schema = upper(sch.name)
      })).privileges
  }

  all_objects_privileges = flatten([
    for key, privileges in local.all_privileges: flatten([
      for obj_type, obj_privs in try(privileges.all_objects, {}): [
        for role_name, privs in transpose(obj_privs): {
          database    = "${var.db_prefix}_${var.environment}_${split(".", key)[0]}"
          schema      = "${var.sc_prefix}_${split(".", key)[1]}"
          role        = "${var.sc_prefix}_${role_name}"
          object_type = obj_type
          privileges  = privs
        }
      ]
    ])
  ])

  future_object_privileges = flatten([
    for key, privileges in local.all_privileges: flatten([
      for obj_type, obj_privs in try(privileges.future_objects, {}): [
        for priv_name, roles in transpose(obj_privs): {
          database    = "${var.db_prefix}_${var.environment}_${split(".", key)[0]}"
          schema      = "${var.sc_prefix}_${split(".", key)[1]}"
          role        = "${var.sc_prefix}_${priv_name}"
          object_type = obj_type
          privileges  = roles
        }
      ]
    ])
  ])
}
