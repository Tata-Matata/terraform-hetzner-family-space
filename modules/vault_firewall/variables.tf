variable "vault_server_id" {
  description = "ID of the Vault server to attach the firewall to"
  type        = string
  
}

# CIDR of the private network that is allowed to access Vault
variable "subnet_cidr" {
  description = "CIDR of the private network allowed to access Vault API"
  type        = string
}

variable "vpn_subnet_cidr" {
  type = string
  description = "Wireguard VPN subnet for admin access, allowed to access Vault via SSH"
}

# port 8200 from VPN subnet and private subnet
variable "vault_api_allowed_cidrs" {
  type = list(string)
  description = "from which CIDRs it is allowed to access Vault API"
  default = [var.subnet_cidr, var.vpn_subnet_cidr]
}

# port 22 only from VPN subnet
variable "vault_ssh_allowed_cidrs" {
  type = list(string)
  description = "from which CIDRs it is allowed to access Vault via SSH"
  default = var.vpn_subnet_cidr
}

