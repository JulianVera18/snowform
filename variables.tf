variable "configs" {
  type = object({
    environment = optional(string)
    team        = optional(string)
    paths       = optional(map(any), {})
    tags        = optional(map(any), {})
  })
}
