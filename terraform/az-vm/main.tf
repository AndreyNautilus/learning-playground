terraform {
  # local backend

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.17.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

locals {
  name   = "vm-linux-lab"
  region = "North Europe"
}

# Resource group
resource "azurerm_resource_group" "group" {
  name     = "rg-${local.name}"
  location = local.region
  tags = {
    "lab" : local.name
  }
}

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

resource "azurerm_public_ip" "public_ip" {
  name                = "pubip-${local.name}"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  allocation_method   = "Static"

  lifecycle {
    # to create first when re-creating
    create_before_destroy = true
  }
}

resource "azurerm_network_interface" "net_interface" {
  name                = "nic-${local.name}"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# VM
resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = "vm-linux-${local.name}"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location

  # available sizes: https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview
  size = "Standard_B1s"
  zone = 2 # check Azure Portal for which zones are available

  network_interface_ids = [
    azurerm_network_interface.net_interface.id,
  ]

  admin_username = "adminuser"
  # TODO: change to ssh
  disable_password_authentication = false
  admin_password                  = "SecretP@ssw0rd"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
