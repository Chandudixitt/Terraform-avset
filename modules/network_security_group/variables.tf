variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

#variable "nsg_name" {
#  description = "The name of the nsg"
#  type        = string
#}

variable "inbound_rules" {
  description = "A list of inbound security rules"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "outbound_rules" {
  description = "A list of outbound security rules"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "subnet_ids" {
  description = "A list of subnet IDs to associate with NSGs"
  type        = list(string)
}

variable "nsg_count" {
  description = "The number of network security groups to create"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(any)
}
