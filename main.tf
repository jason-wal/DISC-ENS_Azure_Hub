# Base elements go here
#############################################################################


resource "azurerm_resource_group" "hub" {
    name     = "${var.prefix}_rsg"
    location = var.az_reg
    tags     = var.tags 
}

# -- Defining the Hub vNet
resource "azurerm_virtual_network" "this" {
    name                    = "${var.prefix}_vNet"
    address_space           = values(var.hub_cidrs_v4)
    location                = var.az_reg
    resource_group_name     = azurerm_resource_group.hub.name
    dns_servers             = var.dns_servers
    tags                    = var.tags
#    bgp_community           = var.ExprRT_BGP_Primary_Community
}

