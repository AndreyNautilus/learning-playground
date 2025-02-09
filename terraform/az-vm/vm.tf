# public IP so I can reach the VM from laptop
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

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.net_interface.id
  network_security_group_id = azurerm_network_security_group.vm_access_from_outside.id
}

# VM
resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = "vm-linux-${local.name}"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location

  # available sizes: https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/overview
  size = "Standard_B1s"
  zone = 2  # check Azure Portal for which zones are available

  network_interface_ids = [
    azurerm_network_interface.net_interface.id,
  ]

  admin_username = "adminuser"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("linuxvm.pub")
  }

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
