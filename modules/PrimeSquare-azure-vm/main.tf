resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.nic_name}-${count.index+1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = element(var.subnet_ids, count.index % length(var.subnet_ids))
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip[count.index].id
  }

  tags = var.tags
}

resource "azurerm_public_ip" "pubip" {
  count               = var.vm_count
  name                = "${var.vm_name}-Public-IP-${count.index+1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_virtual_machine" "vm" {
  count                = var.vm_count
  name                 = "${var.vm_name}-${count.index+1}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  availability_set_id   = element(var.availability_set_ids, count.index < 2 ? 0 : (count.index < 4 ? 1 : 2))
# availability_set_id = subnet_ids[count.index % length(module.subnet.subnet_ids)]
  vm_size              = var.vm_size

  delete_os_disk_on_termination = true
  #delete_data_disks_on_termination = true

  storage_os_disk {
    name                 = "${var.vm_name}-osdisk-${count.index+1}"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size
  }

  storage_image_reference {
    publisher = var.os_image.publisher
    offer     = var.os_image.offer
    sku       = var.os_image.sku
    version   = var.os_image.version
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = var.ssh_public_key
    }
  }

  tags = var.tags
}

output "public_ip_addresses" {
  description = "The public IP addresses of the VMs"
  value       = azurerm_public_ip.pubip[*].ip_address
}

#output "nsg_ids" {
#  description = "The id of the NSG"
#  value = azurerm_network_security_group.nsg[*].id
#}
