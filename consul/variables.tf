variable "hcloud_token" {
  sensitive = true
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
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

# FIREWALL
# Wireguard VPN subnet for cluster admins
# human-initiated traffic
variable "vpn_subnet_cidr" {
  default = "10.100.0.0/24"
}

# CIDR of the private network that is allowed to access Consul
variable "subnet_cidr" {
  description = "CIDR of the private network allowed to access Consul"
  type        = string
  default = data.terraform_remote_state.core_network.outputs.subnet_cidr
}

# port 22 only from VPN subnet
variable "consul_ssh_allowed_cidrs" {
  type = list(string)
  description = "from which CIDRs it is allowed to access Consul via SSH"
  default = var.vpn_subnet_cidr
}

# port 8300 (Consul Servers talking to each other)
# 8301 (Serf gossip protocol used by Consul server and agents) 
# only from private subnet
variable "consul_cluster_cidrs" {
  type = list(string)
  description = "from which CIDRs it is allowed to access Consul Server"
  default = var.subnet_cidr
}

# port 8500 (HTTP API) from private subnet and VPN
# used by Vault, automation
variable "consul_api_allowed_cidrs" {
  type = list(string)
  description = "from which CIDRs it is allowed to access Consul HTTP API"
  default = [var.subnet_cidr, var.vpn_subnet_cidr]
}