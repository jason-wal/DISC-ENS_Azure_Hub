





#
#---------------------------------------------------------
# Create Private DNS RSG
#-------------------------------------------------------------
#


resource "azurerm_resource_group" "hub-dns" {
    name     = "${var.prefix}_dns-rsg"
    location = var.az_reg
    tags     = var.tags 
}

resource "azurerm_private_dns_zone" "this" {
    for_each = toset(var.private-dns-zones)
        name                = each.key
        resource_group_name = azurerm_resource_group.hub-dns.name
        tags                = var.tags 
        soa_record {
            email           = var.zone_soa.email
            expire_time     = var.zone.expire_time 
            minimum_ttl     = var.zone.min_ttl   
            refresh_time    = var.zone.refresh_time
            retry_time      = var.zone.retry_type 
            ttl             = var.zone.ttl            
        }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = toset(var.private-dns-zones)
    name                    = each.key
    resource_group_name     = azurerm_resource_group.hub-dns.name
    private_dns_zone_name   = each.key
    virtual_network_id      = azurerm_virtual_network.this.id
    registration_enabled    = false
    tags                    = var.tags 
}












