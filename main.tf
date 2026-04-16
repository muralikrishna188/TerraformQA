terraform {
  backend "azurerm" {
    resource_group_name = "Amazon-US-RG"
    storage_account_name = "amzstg0014"
    container_name = "devcontainer"
    key = "terraform.devcontainer"
    access_key = "c8BwUiVXkkjchMpQi6Yb/1SAi8bPVPwYq7BktPUkb4CqwGeV3Q1dQE05xhOErA6mxAAP4pszVagI+AStcfl9Gg=="
    
  }
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "4.57.0"
    }
  }
}

variable "subscription_id" {
    type = string
    default = "049cc0b9-2696-4e70-871b-4366be487c19"
    description = "myenv subscription id"
  
}
variable "client_id" {
    type = string 
    default = "59add09e-4b52-4e40-87ec-10ed6ae02116"
    description = "my env client id"
  
}
variable "client_secret" {
    type = string 
    default = "baN8Q~yNuxrpjetk-ripJkLwlQW_-~n22iTRGaja"
    description = "myenv client secret"
  
}
variable "tenant_id" {
    type = string
    default = "477cf0a5-266c-4331-8f0a-865f4622d888"
  
}

provider "azurerm" {
    features {
      
    }
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id

  
}
resource "azurerm_resource_group" "azprodrglabel01" {
    name = "myprodrg"
    location = "eastus"
  
}

resource "azurerm_virtual_network" "azprodvnetlabel01" {
    name = "azprovnet01"
    location = azurerm_resource_group.azprodrglabel01.location
    resource_group_name = azurerm_resource_group.azprodrglabel01.name
    address_space = [ "10.70.0.0/16" ]

  
}

resource "azurerm_subnet" "azwebsubnet001" {
  name = "websubnet"
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  virtual_network_name = azurerm_virtual_network.azprodvnetlabel01.name
  address_prefixes = [ "10.70.1.0/24" ]
  
}
resource "azurerm_public_ip" "azwebpubiplabel001" {
  name = "azwebpublicip01"
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  location = azurerm_resource_group.azprodrglabel01.location
  allocation_method = "Static"
  
}
resource "azurerm_network_interface" "azwebniclabel001" {
  name = "azwebnic01"
  location = azurerm_resource_group.azprodrglabel01.location
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  ip_configuration {
    name = "webnicocnfig"
    subnet_id = azurerm_subnet.azwebsubnet001.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.azwebpubiplabel001.id
  }
  
}
resource "azurerm_linux_virtual_machine" "azwebvmlabel01" {
  name = "azwebesrver01"
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  location = azurerm_resource_group.azprodrglabel01.location
  size = "Standard_F2"
  admin_username = "adminuser"
  network_interface_ids = [azurerm_network_interface.azwebniclabel001.id,]
  admin_ssh_key {
    username = "adminuser"
    public_key = file("~/.ssh/id_ed25519.pub")
  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }

}


resource "azurerm_subnet" "azappsubnet001" {
  name = "appsubnet"
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  virtual_network_name = azurerm_virtual_network.azprodvnetlabel01.name
  address_prefixes = [ "10.70.2.0/24" ]
  
}
resource "azurerm_public_ip" "azappubiplabel001" {
  name = "azapppublicip01"
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  location = azurerm_resource_group.azprodrglabel01.location
  allocation_method = "Static"
  
}
resource "azurerm_network_interface" "azappniclabel001" {
  name = "azappnic01"
  location = azurerm_resource_group.azprodrglabel01.location
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  ip_configuration {
    name = "appnicocnfig"
    subnet_id = azurerm_subnet.azappsubnet001.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.azappubiplabel001.id
  }
  
}
resource "azurerm_linux_virtual_machine" "azappvmlabel01" {
  name = "azappsrver01"
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  location = azurerm_resource_group.azprodrglabel01.location
  size = "Standard_F2"
  admin_username = "adminuser"
  network_interface_ids = [azurerm_network_interface.azappniclabel001.id,]
  admin_ssh_key {
    username = "adminuser"
    public_key = file("~/.ssh/id_ed25519.pub")
  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }

}


resource "azurerm_subnet" "azdbsubnet001" {
  name = "dbsubnet"
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  virtual_network_name = azurerm_virtual_network.azprodvnetlabel01.name
  address_prefixes = [ "10.70.3.0/24" ]
  
}
resource "azurerm_public_ip" "azdbpubiplabel001" {
  name = "azdbpublicip01"
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  location = azurerm_resource_group.azprodrglabel01.location
  allocation_method = "Static"
  
}
resource "azurerm_network_interface" "azdbniclabel001" {
  name = "azdbnic01"
  location = azurerm_resource_group.azprodrglabel01.location
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  ip_configuration {
    name = "dbnicocnfig"
    subnet_id = azurerm_subnet.azdbsubnet001.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.azdbpubiplabel001.id
  }
  
}
resource "azurerm_linux_virtual_machine" "azdbvmlabel01" {
  name = "azdbsrver01"
  resource_group_name = azurerm_resource_group.azprodrglabel01.name
  location = azurerm_resource_group.azprodrglabel01.location
  size = "Standard_F2"
  admin_username = "adminuser"
  network_interface_ids = [azurerm_network_interface.azdbniclabel001.id,]
  admin_ssh_key {
    username = "adminuser"
    public_key = file("~/.ssh/id_ed25519.pub")
  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }

}


