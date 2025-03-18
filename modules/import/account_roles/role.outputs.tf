output "locals" {
  value = {
    roles          = var.roles
    privileges     = var.privileges
    db_role_grants = local.db_role_grants
  }
}
