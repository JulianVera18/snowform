# input to parent main.tf
configs = {
  environment = "dev"
  team        = "admins"
  paths = {
    resources = "configs/admins"
    templates = "configs/templates/rbac"
  }
  tags  = {
    env         = "dev"
    version     = "1.0"
    cost_center = ""
  }
}
