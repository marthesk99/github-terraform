locals {
  workspace_suffix = terraform.workspace == "default" ? "" : terraform.workspace
  rg_name          = "${var.rg_name}-${local.workspace_suffix}"
  sa_name          = "${var.sa_name}${random_string.random_string.result}"
  dynamic_content  = "<h1>Web page created with Terraform: ${terraform.workspace}</h1>"
}

resource "random_string" "random_string" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = var.index_document
  }
}

resource "azurerm_storage_blob" "blob" {
  name                   = var.index_document
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = local.dynamic_content
}

output "primary_web_endpoint" {
  value = azurerm_storage_account.sa.primary_web_endpoint
}
