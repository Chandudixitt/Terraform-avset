variable "vm_name" {
  description = "The name of the VM"
  type        = string
}

variable "vm_size" {
  description = "The size of the VM"
  type        = string
}

variable "username" {
  description = "The admin username of the VM"
  type        = string
}

variable "os_image" {
  description = "The OS image to use for the VM"
  type        = map(string)
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_ids" {
  description = "The ID of the subnet"
  type        = list(string)
}

variable "availability_set_ids" {
  description = "List of availability set IDs"
  type        = list(string)
}

variable "nic_name" {
  description = "The name of NIC"
  type        = string
}

variable "vm_count" {
  description = "The number of VMs to create"
  type        = number
}

variable "os_disk_size" {
  description = "The size of the OS disk in GB"
  type        = number
}

variable "ssh_public_key" {
  description = "SSH public key for VMs"
  type        = string
}

#variable "nsg_ids" {
#  description = "NSG ids for nic"
#  type        = list(string)
#}

variable "os_disk_storage_account_type" {
  description = "Specifies the storage account type of the os disk of the virtual machine"
  default     = "Standard_LRS"
  type        = string
}

variable "nsg_name" {
  description = "The names of the network security groups"
  type        = string
}

variable "inbound_rules" {
  description = "The inbound security rules"
  type        = list(object({
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
  description = "The outbound security rules"
  type        = list(object({
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

variable "tags" {
  description = "Tags for the resources"
  type        = map(any)
}
