variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the vnet"
  type        = string
}

variable "subnet_count" {
  description = "The number of subnets to create"
  type        = number
}

variable "subnet_details" {
  description = "Details of the subnets to create"
  type = list(object({
    name           = string
    address_prefix = string
  }))
}
