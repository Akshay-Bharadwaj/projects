terraform {
  backend "azurerm" {
    resource_group_name  = ""
    storage_account_name = ""             
    container_name       = "tfstate"                       
    key                  = "dev.terraform.tfstate"   
  }
  }

# Can be passed as, tf init`-backend-config=`"resource_group_name=<resource group name> container_name=<container name> key=<blob key name>"
