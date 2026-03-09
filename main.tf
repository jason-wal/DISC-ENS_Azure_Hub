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
    address_space           = values(merge(var.hub_cidrs_v4, var.hub_cidrs_v6))
    location                = var.az_reg
    resource_group_name     = azurerm_resource_group.hub.name
    dns_servers             = var.dns_servers
    tags                    = var.tags
#    bgp_community           = var.ExprRT_BGP_Primary_Community
}

#---------------------------------------------------------
# Route Tables
#-------------------------------------------------------------
#

resource "azurerm_route_table" "this" {
    for_each = var.hub_subnets
        name                            = "${each.key}_UDR"
        location                        = var.az_reg
        resource_group_name             = azurerm_resource_group.hub.name
        bgp_route_propagation_enabled   = each.key == "GatewaySubnet" || each.key == strcontains(each.key, "Bastion" )  || each.key == strcontains(each.key, "EXT") ? true : false
        tags                            = var.tags
}




#---------------------------------------------------------
# Create Routes for Express_RT_GW pointed to FW floating external IP
#-------------------------------------------------------------
#

resource "azurerm_route" "hub_v4" {
  for_each = var.hub_cidrs_v4  
    name                    = each.key
    resource_group_name     = azurerm_resource_group.hub.name
    route_table_name        = "GatewaySubnet_UDR"
    address_prefix          = each.value
    next_hop_type           = "VirtualAppliance" 
    next_hop_in_ip_address  = var.fw_floating_v4_ips["FW_Float_EXT_v4_IP"]
}

resource "azurerm_route" "hub_v6" {
  for_each = var.hub_cidrs_v6
    name                    = each.key
    resource_group_name     = azurerm_resource_group.hub.name
    route_table_name        = "GatewaySubnet_UDR"
    address_prefix          = each.value
    next_hop_type           = "VirtualAppliance" 
    next_hop_in_ip_address  = var.fw_floating_v6_ips["FW_Float_EXT_v6_IP"]
}

resource "azurerm_route" "spoke_v4" {
  for_each = var.spoke_cidrs_v4  
    name                    = each.key
    resource_group_name     = azurerm_resource_group.hub.name
    route_table_name        = "GatewaySubnet_UDR"
    address_prefix          = each.value
    next_hop_type           = "VirtualAppliance" 
    next_hop_in_ip_address  = var.fw_floating_v4_ips["FW_Float_EXT_v4_IP"]
}

resource "azurerm_route" "spoke_v6" {
  for_each = var.spoke_cidrs_v6
    name                    = each.key
    resource_group_name     = azurerm_resource_group.hub.name
    route_table_name        = "GatewaySubnet_UDR"
    address_prefix          = each.value
    next_hop_type           = "VirtualAppliance" 
    next_hop_in_ip_address  = var.fw_floating_v6_ips["FW_Float_EXT_v6_IP"]
}





#---------------------------------------------------------
# Create Subnets
#-------------------------------------------------------------
#

resource "azurerm_subnet" "this" {
  for_each = var.hub_subnets
    name                              = each.key
    resource_group_name               = azurerm_resource_group.hub.name
    virtual_network_name              = azurerm_virtual_network.this.name
    address_prefixes                  = each.value["Subs"] 
    service_endpoints                 = contains( each.value["Sub_Svc_Endpoints"], "null" ) ? null : each.value["Sub_Svc_Endpoints"]
    private_endpoint_network_policies = each.value["priv_endpt"] ? "Disabled" : "Enabled"
    default_outbound_access_enabled   = each.value["default_outbound_access_enabled"]  

    dynamic "delegation" {
        for_each = each.value["Sub_Delegation"] ? [1] : [] 
        content {
          name = each.value["Sub_Delegation_Name"]
          service_delegation {
            actions = each.value["Sub_Delegation_Actions"]
            name    = each.value["Sub_Delegation_Actions_Name"]
          }
        }
     }
}




#---------------------------------------------------------
# Associate Route Tables to subnets
#-------------------------------------------------------------
#
resource "azurerm_subnet_route_table_association" "this" {
  for_each = var.hub_subnets  
    subnet_id      = azurerm_subnet.this[each.key].id
    route_table_id = azurerm_route_table.this[each.key].id
}




