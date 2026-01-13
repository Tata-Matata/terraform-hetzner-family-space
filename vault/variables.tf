variable "hcloud_token" {
  sensitive = true
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

# Wireguard VPN subnet for cluster admins
# human-initiated traffic
variable "vpn_subnet_cidr" {
  default = "10.100.0.0/24"
}

# Private subnet CIDR where Vault server will be deployed
variable "subnet_cidr" {
  description = "Private subnet CIDR for cluster, Vault and Consul"
  default = data.terraform_remote_state.core_network.outputs.subnet_cidr
}

# Offset for Vault server IP in the private subnet
variable "host_offset_vault" {
  description = "Host offset for Vault server IP in the subnet"
  type        = number
  default     = 20

  validation {
    condition     = var.host_offset > 19 && var.host_offset < 26
    error_message = "Host offset must be in range 20-25"
  }
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

