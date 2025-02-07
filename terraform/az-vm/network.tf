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
