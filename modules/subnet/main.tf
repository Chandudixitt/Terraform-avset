resource "azurerm_subnet" "subnet" {
  count                = var.subnet_count
  name                 = var.subnet_details[count.index].name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.subnet_details[count.index].address_prefix]
}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = azurerm_subnet.subnet[*].id
}

