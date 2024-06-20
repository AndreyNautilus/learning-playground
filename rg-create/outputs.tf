output "names" {
  value = azurerm_resource_group.rg-group[*].name
}