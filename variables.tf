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

/*
variable "hub_cidrs_v6" {
    type = map(string)
    description = "Map of IPv6 hub CIDRs for region"
}
*/