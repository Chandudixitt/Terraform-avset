terraform {
  backend "azurerm" {
    resource_group_name   = "PrimeSquare-IAC-Resource-Group"
    storage_account_name  = "primesquareiacdemosa"
    container_name        = "terraform-state-cont"
    key                   = "terraform.tfstate"
    use_msi               = true
    client_id             = "9cd0a1f5-d29f-4b48-bc12-4dfd9df70736"
    access_key            = "eQ+vznhoalz+1KUgJZEDlNxcTnK2xXMPRz6cpqlTRiQWf69+31vUj1ZGGZOEFv1fFYhCiY6YcWss+ASt0Nzx9A=="
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}

  subscription_id = var.subscription_id
}

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

module "network_security_group" {
  source               = "./modules/network_security_group"
  location             = var.location
  resource_group_name  = var.resource_group_name
  inbound_rules        = var.inbound_rules
  outbound_rules       = var.outbound_rules
  subnet_ids           = module.subnet.subnet_ids
 #nsg_name             = var.nsg_name
  tags                 = var.tags
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
