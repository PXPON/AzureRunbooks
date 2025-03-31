provider "azurerm" {
    subscription_id = "0dc2ac06-ab33-4bc1-9df3-bc0a61c163f9"
    features {}
}

variable "project_tag" {
    type = map(string)
    default = {
        Project = "rb-project"
    }
}


resource "azurerm_resource_group" "runbook_project" {
    name = "rg_rb-project"
    location = "West US 2"
    tags = {
        Project = "rb-project"
    }
}

# Create a Storage Account
resource "azurerm_storage_account" "runbook_project" {
    name = "sarbproject"
    resource_group_name = azurerm_resource_group.runbook_project.name
    location = azurerm_resource_group.runbook_project.location
    account_replication_type = "LRS"

    account_tier = "Standard"
    tags = var.project_tag
}

# Create blob storage
resource "azurerm_storage_container" "runbook_project" {
    name = "scrbproject"
    storage_account_name = azurerm_storage_account.runbook_project.name

}

# Create an automation account
resource "azurerm_automation_account" "runbook_project" {
    name = "acrbproject"
    resource_group_name = azurerm_resource_group.runbook_project.name
    sku_name = "Free"
    location = "West US 2"
}

resource "azurerm_automation_runbook" "runbook_project" {
    name = "rb-first_runbook"
    resource_group_name = azurerm_resource_group.runbook_project.name
    automation_account_name = azurerm_automation_account.runbook_project.name
    location = "West US 2"

    runbook_type = "Python3"
    publish_content_link {
      uri = ""
    }

    content = <<-EOT
        print("Hello World from Azure Automation!")
    EOT

    log_verbose = true
    log_progress = true

}
