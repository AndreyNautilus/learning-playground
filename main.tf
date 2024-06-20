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
  
  group-name = var.group-name
  amount = 2
}

data "azurerm_resource_group" "exsiting_group" {
  name = module.rg-create.names[0]

  depends_on = [
    module.rg-create
  ]
}
