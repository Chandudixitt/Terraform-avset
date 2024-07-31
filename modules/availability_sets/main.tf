resource "azurerm_availability_set" "avset" {
  count               = length(var.availability_set_details)
  name                = var.availability_set_details[count.index].name
  location            = var.location
  resource_group_name = var.resource_group_name
  managed = true
  platform_fault_domain_count    = var.availability_set_details[count.index].fault_domain_count
  platform_update_domain_count   = var.availability_set_details[count.index].update_domain_count
}

output "availability_set_ids" {
  description = "The IDs of the availability sets"
  value       = azurerm_availability_set.avset[*].id
}
