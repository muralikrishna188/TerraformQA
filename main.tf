terraform {

  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "4.27.0"
    }
  }
}
provider "azurerm" {
    features {
      
    }
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id

  
}
locals {
  setup_name = "amazon-hyd"
}
resource "azurerm_resource_group" "azapprg101" {
    name = "azureapprg003"
    location = "central us"
    tags = {
      "name" = "${local.setup_name}-rsg"
    }
  
}
resource "azurerm_service_plan" "azappplan101" {
    name = "devazappplan"
    resource_group_name = azurerm_resource_group.azapprg101.name
    location = azurerm_resource_group.azapprg101.location
    sku_name = "S1"
    os_type = "Windows"
    tags = {
      "name" = "${local.setup_name}-appplan"
    }
  
}
resource "azurerm_windows_web_app" "azwebapp101" {
    name = "mywebapp02456"
    resource_group_name = azurerm_resource_group.azapprg101.name
    location = azurerm_resource_group.azapprg101.location
    service_plan_id = azurerm_service_plan.azappplan101.id
    depends_on = [ azurerm_service_plan.azappplan101 ]
    site_config {
      
    }
    tags = {
      "name" = "${local.setup_name}-webapp"
    }
  
}
