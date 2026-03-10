#Define Variables
variable "prefix" {
    type        = string
    description = "variable prefix to append at beginning of names"
}

variable "az_reg" {
    type        = string 
    description = "local region"
}

variable "tags" {
    type = map(string)
}

variable "dns_servers" {
    type        = list(string)
    description = "DNS Servers to use"
}

variable "hub_cidrs_v4" {
    type = map(string)
    description = "Map of IPv4 hub CIDRs for region"
}

variable "hub_cidrs_v6" {
    type = map(string)
    description = "Map of IPv6 hub CIDRs for region"
}

variable "hub_subnets" {
    description = "subnet definition variable"
    type = map(object({
        Subs                            = list(string)
        Sub_Svc_Endpoints               = list(string)
        Sub_Delegation                  = bool
        Sub_Delegation_Name             = string
        Sub_Delegation_Actions_Name     = string
        Sub_Delegation_Actions          = list(string)
        priv_endpt                      = string
        default_outbound_access_enabled = bool
    }))
}




variable "spoke_cidrs_v4" {
    type = map(string)
    description = "Map of IPv4 spoke CIDRs for region"
}

variable "spoke_cidrs_v6" {
    type = map(string)
    description = "Map of IPv6 Spoke CIDRs for region"
}



variable "fw1_interfaces" {
    description = "Firewall interface definition variable for fw1"
    type = map(object({
        v4_IP  = string
        v6_IP  = string
        sub    = string
    }))
}

variable "fw2_interfaces" {
    description = "Firewall interface definition variable for fw2"
    type = map(object({
        v4_IP  = string
        v6_IP  = string
        sub    = string
    }))
}


variable "fw_floating_interfaces" {
    description = "Firewall interface definition variable for floating interfaces"
    type = map(object({
        v4_IP  = string
        v6_IP  = string
        sub    = string
    }))
}


variable "fw1-config" {
    type        = string 
    description = "firewall config passed to hub"
}

variable "fw2-config" {
    type        = string 
    description = "firewall config passed to hub"
}

variable "aName" {
    type = string
}

variable "aPass" {
    type        = string
    sensitive   = true
}

variable "fw_vm_size" {
    type = string 
    default = "Standard_DS8_v5"
}

variable "fw_publisher" {
    type = string 

}

variable "fw_offer" {
    type = string 

}

variable "fw_os_sku" {
    type = string 

}

variable "fw_version" {
    type = string 

}

variable "er_gw_sku" {
    type = string 

}

variable "strg_tls_min_ver" {
    type        = string 
    description = "Firewall Storage account min TLS Version"  # Only used in commercial
    default     = null
}




variable "express_routes" {
    description = "Settings for express_routes"
    type = map(object({
        weight                      = string
        circuit_id                  = string 
        auth_key                    = string 
        ergw_bypass                 = bool
        pol_based_traffic_selector  = bool
        shared_key                  = string 
    }))
    default={
        weight                      = null
        circuit_id                  = null
        auth_key                    = null
        ergw_bypass                 = null
        pol_based_traffic_selector  = null
        shared_key                  = null
    }
}