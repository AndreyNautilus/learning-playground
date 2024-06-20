locals {
    rg-prefix = "rg-"
}

resource "azurerm_resource_group" "rg-group" {
  count = var.amount

  name     = "${local.rg-prefix}${var.group-name}-${count.index}"
  location = var.region
  tags     = var.tags

  # local-exec example
  provisioner "local-exec" {
    command = "echo RG ${self.name} is created: ${self.id}"
  }
}