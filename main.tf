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

provider "azurerm" {
  # Configuration options
  features {}

  alias = "secondary"
}

locals {
  region = "West Europe"
}

module "rg-create" {
  source = "./rg-create"
  providers = {
    azurerm = azurerm.secondary
  }

  group-name = var.group-name
  region     = local.region
  amount     = 2
}

data "azurerm_resource_group" "exsiting_group" {
  provider = azurerm.secondary
  name = module.rg-create.names[0]

  depends_on = [
    module.rg-create
  ]
}

resource "azurerm_resource_group" "another_group" {
  name     = "rg-another-group"
  location = local.region

  lifecycle {
    prevent_destroy = false  # true
  }
}