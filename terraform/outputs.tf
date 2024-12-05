output "rg-names" {
  value = module.rg-create.names
}

output "id" {
  value = data.azurerm_resource_group.exsiting_group.id
}