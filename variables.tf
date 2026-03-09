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
        priv_endpt                      = bool
        default_outbound_access_enabled = bool
    }))
}





variable "fw1_v4_ips" {
    type = map(string)
    description = "FW1 interface IPv4 IPs"
}

variable "fw1_v6_ips" {
    type = map(string)
    description = "FW1 interface IPv6 IPs"
}


variable "fw2_v4_ips" {
    type = map(string)
    description = "FW2 interface IPv4 IPs"
}

variable "fw2_v6_ips" {
    type = map(string)
    description = "FW2 interface IPv6 IPs"
}


variable "fw_floating_v4_ips" {
    type = map(string)
    description = "FW floating interface IPv4 IPs"
}

variable "fw_floating_v6_ips" {
    type = map(string)
    description = "FW floating interface IPv6 IPs"
}


variable "spoke_cidrs_v4" {
    type = map(string)
    description = "Map of IPv4 spoke CIDRs for region"
}

variable "spoke_cidrs_v6" {
    type = map(string)
    description = "Map of IPv6 Spoke CIDRs for region"
}























