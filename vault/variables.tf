variable "hcloud_token" {
  sensitive = true
}


# Wireguard VPN subnet for cluster admins
# human-initiated traffic to Vault
variable "vpn_subnet_cidr" {

  description = "CIDR of the Wireguard VPN subnet"
  validation {
    condition     = can(cidrnetmask(var.vpn_subnet_cidr))
    error_message = "vpn_subnet_cidr must be a valid CIDR block"
  }
}


locals { 
  # Private subnet CIDR where Vault server will be deployed
  subnet_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr

  # port 8200 from VPN subnet and private subnet
  vault_api_allowed_cidrs = [
    local.subnet_cidr,
    var.vpn_subnet_cidr
  ]

  # port 22 only from VPN subnet
  vault_ssh_allowed_cidrs = [
    var.vpn_subnet_cidr
  ]
}

# Offset for Vault server IP in the private subnet
variable "host_offset_vault" {
  description = "Host offset for Vault server IP in the subnet"
  type        = number
  default     = 20

  validation {
    condition     = var.host_offset_vault > 19 && var.host_offset_vault < 26
    error_message = "Host offset must be in range 20-25"
  }
}


