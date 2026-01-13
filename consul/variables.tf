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


variable "host_offset_consul" {
  description = "Host offset for Consul server IP in the subnet"
  type        = number
  default     = 10

  validation {
    condition     = var.host_offset > 9 && var.host_offset < 16
    error_message = "Host offset must be in range 10-15"
  }


}
