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