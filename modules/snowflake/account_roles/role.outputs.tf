output "locals" {
  value = {
    hierarchy      = local.hyerarchy
    privileges     = local.privileges
    all_roles      = local.all_roles
    all_privileges = local.all_privileges
    # ownership_roles = local.ownership_roles
  }
}
