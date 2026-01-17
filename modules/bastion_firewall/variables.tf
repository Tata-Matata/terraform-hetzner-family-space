# Wireguard VPN subnet for cluster admins
# human-initiated traffic to Bastion
variable "vpn_subnet_cidr" {
  type        = string
  description = "CIDR of the Wireguard VPN subnet"
  validation {
    condition     = can(cidrnetmask(var.vpn_subnet_cidr))
    error_message = "vpn_subnet_cidr must be a valid CIDR block"
  }
}




