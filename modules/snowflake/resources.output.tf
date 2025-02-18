output "test" {
  value = {
    configs = var.configs
    wh      = local.warehouses
    snow_wh = module.warehouses.warehouses
  }
}
