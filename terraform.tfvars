subscription_id     = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
resource_group_name = "PrimeSquare-IAC-Resource-Group"
location            = "Central India"
virtual_network_name = "PrimeSquare-IAC-VNET"

subnet_details = [
  { name = "web-subnet-1", address_prefix = "10.2.0.0/27" },
  { name = "web-subnet-2", address_prefix = "10.2.0.32/27" },
  { name = "app-subnet-1", address_prefix = "10.2.0.64/27" },
  { name = "app-subnet-2", address_prefix = "10.2.0.96/27" },
  { name = "msg-subnet-1", address_prefix = "10.2.0.128/27" },
  { name = "msg-subnet-2", address_prefix = "10.2.0.160/27" },
  { name = "msg-subnet-3", address_prefix = "10.2.0.192/27" },
  { name = "msg-subnet-4", address_prefix = "10.2.0.224/27" }
]

availability_set_details = [
  { name = "webserver-avset", fault_domain_count = 2, update_domain_count = 5 },
  { name = "appserver-avset", fault_domain_count = 2, update_domain_count = 5 },
  { name = "MSGserver-avset", fault_domain_count = 2, update_domain_count = 5 }
]

nic_name            = "PrimeSquare-IAC-NIC"
nsg_name            = "PrimeSquare-IAC-NSG"
storage_account     = "primesquareiacdemosa"
storage_container   = "terraform-private-key"

vm_details = [
  {
    vm_name  = "PrimeSquare-IAC-VM"
    vm_count = 7
    vm_size  = "Standard_DS1_v2"
    disk_type = "Standard_LRS"
    os_disk_size = 32
    username = "azureuser"
    os_image = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-LTS"
      version   = "latest"
    }
  }
]

inbound_rules = [
  {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "111.93.10.210/32"
    destination_address_prefix = "*"
  },
  {
    name                       = "AllowHTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "111.93.10.210/32"
    destination_address_prefix = "*"
  }
]

outbound_rules = [
  {
    name                       = "AllowAllOut"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

tags = {
  Environment = "Development"
  Project     = "PrimeSquare-IAC"
}
