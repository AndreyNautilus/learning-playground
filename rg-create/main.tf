locals {
    rg-prefix = "rg-"
}

resource "azurerm_resource_group" "tf-group" {
  name     = "${local.rg-prefix}${var.group-name}"
  location = var.region

  # local-exec example
  provisioner "local-exec" {
    command = "echo RG ${self.name} is created"
  }
}