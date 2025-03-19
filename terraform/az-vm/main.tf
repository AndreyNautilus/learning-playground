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
