terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg_backend_msk"
    storage_account_name = "sabkmskpdi"
    container_name       = "sc-backend-msk"
    key                  = "ws-kvbkmsk"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}