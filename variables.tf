variable "subscription_id" {
  description = "The name of the subscription id"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "virtual_network_name" {
  description = "The names of the vnet"
  type        = string
}

#variable "subnet_ids" {
#  description = "The ID of the subnet"
#  type        = list(string)
#}

variable "subnet_details" {
  description = "Details of the subnets to create"
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "availability_set_details" {
  description = "Details of the availability sets"
  type = list(object({
    name = string
    fault_domain_count    = number
    update_domain_count   = number
  }))
}

variable "nic_name" {
  description = "The name of the nic"
  type        = string
}

#variable "nsg_ids" {
#  description = "List of Network Security Group IDs"
#  type        = list(string)
#}

variable "storage_account" {
  description = "storage account name"
  type        = string
}

variable "storage_container" {
  description = "storage container name"
  type        = string
}

variable "os_disk_storage_account_type" {
  description = "(Optional) Specifies the storage account type of the os disk of the virtual machine"
  default     = "Standard_LRS"
  type        = string
}

variable "nsg_name" {
  description = "The names of the network security groups"
  type        = string
}

variable "vm_details" {
  description = "Details of VMs to be created"
  type = list(object({
    vm_name     = string
    vm_size     = string
    vm_count    = number
    disk_type   = string
    os_disk_size = number
    username    = string
    os_image    = map(string)
  }))
}

variable "inbound_rules" {
  description = "Details of NSG rules to be created"
  type = list(object({
    name        = string
    priority    = number
    direction   = string
    access      = string
    protocol    = string
    source_port_range = string
    destination_port_range = string
    source_address_prefix = string
    destination_address_prefix = string
  }))
}

variable "outbound_rules" {
  description = "Details of outbound NSG rules to be created"
  type = list(object({
    name        = string
    priority    = number
    direction   = string
    access      = string
    protocol    = string
    source_port_range = string
    destination_port_range = string
    source_address_prefix = string
    destination_address_prefix = string
  }))
}

variable "tags" {
  type        = map(any)
  description = "Tags for the resources"
}

