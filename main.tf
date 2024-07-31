terraform {
  backend "azurerm" {
    resource_group_name   = "demosatatergnew"
    storage_account_name  = "demostatesa1234"
    container_name        = "terraform-state-cont"
    key                   = "terraform.tfstate"
    use_msi               = true
    client_id             = "0a30e140-be26-4b86-a1cf-5ed6de57d5ea"
    access_key            = "Cy/sgBF2wo48rv3YivP6b3OFwAeATZ7BhDj6RbWKmTdxt3Ys7KP/HhH8S1X8NAtoncZLFDWaBSnR+ASt4GDhGw=="
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}

  subscription_id = var.subscription_id
}

#module "network_security_group" {
#  source                = "./modules/PrimeSquare-network_security_group"
#  vm_count              = length(var.vm_details)
#  resource_group_name   = var.resource_group_name
#  location              = var.location
#  nsg_name              = var.nsg_name
#  nic_name              = var.nic_name
#  inbound_rules         = var.inbound_rules
#  outbound_rules        = var.outbound_rules
#  tags                  = var.tags
#}

resource "tls_private_key" "sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.sshkey.private_key_pem
  filename = "${path.module}/private_key.pem"
}

resource "azurerm_storage_blob" "private_ssh_key" {
  name                   = "private_ssh_key.pem"
  storage_account_name   = var.storage_account
  storage_container_name = var.storage_container
  type                   = "Block"
  source                 = local_file.private_key.filename
}

module "subnet" {
  source               = "./modules/subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name 
  subnet_count         = length(var.subnet_details)
  subnet_details       = var.subnet_details
}

module "availability_set" {
  source              = "./modules/availability_sets"
  availability_set_details = var.availability_set_details
  resource_group_name  = var.resource_group_name
  location             = var.location
}  

module "vm" {
  source                       = "./modules/PrimeSquare-azure-vm"
  count                        = length(var.vm_details)
  vm_name                      = var.vm_details[count.index].vm_name
  vm_count                     = var.vm_details[count.index].vm_count
  vm_size                      = var.vm_details[count.index].vm_size
  username                     = var.vm_details[count.index].username
  os_disk_storage_account_type = var.vm_details[count.index].disk_type
  os_disk_size                 = var.vm_details[count.index].os_disk_size
  os_image                     = var.vm_details[count.index].os_image
  location                     = var.location
  resource_group_name          = var.resource_group_name
  subnet_ids                   = module.subnet.subnet_ids
  nic_name                     = var.nic_name
  nsg_name                     = var.nsg_name
  inbound_rules                = var.inbound_rules
  outbound_rules               = var.outbound_rules
  ssh_public_key               = tls_private_key.sshkey.public_key_openssh
  availability_set_ids         = module.availability_set.availability_set_ids
  tags                         = var.tags
}
