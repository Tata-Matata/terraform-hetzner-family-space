variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token"
  sensitive   = true
}


variable "host_offset_consul" {
  description = "Host offset for Consul server IP in the subnet"
  type        = number
  default     = 10

  validation {
    condition     = var.host_offset_consul > 9 && var.host_offset_consul < 16
    error_message = "Host offset must be in range 10-15"
  }
}

# FIREWALL
# Wireguard VPN subnet for cluster admins
# human-initiated traffic to Consul
variable "vpn_subnet_cidr" {
  type        = string
  description = "CIDR of the Wireguard VPN subnet"
  validation {
    condition     = can(cidrnetmask(var.vpn_subnet_cidr))
    error_message = "vpn_subnet_cidr must be a valid CIDR block"
  }
}

locals {
  # CIDR of the private network that is allowed to access Consul
  subnet_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr

  # port 22 only from VPN subnet
  consul_ssh_allowed_cidrs = [var.vpn_subnet_cidr]

  # port 8300 (Consul Servers talking to each other)
  # 8301 (Serf gossip protocol used by Consul server and agents) 
  # only from private subnet
  consul_cluster_cidrs = [local.subnet_cidr]

  # port 8500 (HTTP API) from private subnet and VPN
  # used by Vault, automation
  consul_api_allowed_cidrs = [local.subnet_cidr, var.vpn_subnet_cidr]

}



