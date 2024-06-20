terraform {
  # local backend

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.108.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

module "rg-create" {
  source = "./rg-create"
  
  name = var.group-name
}

# resource "azurerm_resource_group" "tf-group" {
#   name     = var.group-name
#   location = var.region

#   # local-exec example
#   provisioner "local-exec" {
#     command = "echo RG ${self.name} is created"
#   }
# }