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
