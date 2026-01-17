variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token"
  sensitive   = true
}

variable "min_ip" {
  description = "Minimum IP address in the subnet"
  type        = number
  default     = 1
}

variable "max_ip" {
  description = "Maximum IP address in the subnet"
  type        = number
  default     = 10

}

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

variable "host_offset_bastion" {
  description = "Host offset for Bastion server IP in the subnet"
  type        = number
  default     = 5

  validation {
    condition = alltrue([

      var.host_offset_bastion >= var.min_ip,
      var.host_offset_bastion <= var.max_ip
    ])

    error_message = "Host offset must be in range ${var.min_ip}-${var.max_ip} to avoid IP conflicts in the subnet."
  }

}
