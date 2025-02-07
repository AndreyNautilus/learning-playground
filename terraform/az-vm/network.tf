# network
resource "azurerm_virtual_network" "vnetwork" {
  name     = "vn-${local.name}"
  location = local.region

  resource_group_name = azurerm_resource_group.group.name

  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "default" {
  name                 = "subn-${local.name}-default"
  resource_group_name  = azurerm_resource_group.group.name
  virtual_network_name = azurerm_virtual_network.vnetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "vm_access_from_outside" {
  name                = "nsg-${local.name}"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  security_rule {
    name        = "SSH"
    description = "Allow inbound SSH"

    priority  = 100
    direction = "Inbound"
    access    = "Allow"

    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*" # from any source
    destination_address_prefix = "*"
  }
}
