variable "import_path" {
  type = string
  default = "./imports.yaml"
}

variable "environment" {
  type    = string
  default = "DEV"  #se puede sobrescribir con un `.tfvars`
}
