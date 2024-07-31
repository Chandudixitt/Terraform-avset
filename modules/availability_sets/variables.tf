variable "resource_group_name" {
  description = "resource grp name"
  type = string
}

variable "location" {
  description = "location name"
  type = string
}

variable "availability_set_details" {
  description = "Details of the availability sets"
  type = list(object({
    name = string
    fault_domain_count    = number
    update_domain_count   = number
  }))
}
