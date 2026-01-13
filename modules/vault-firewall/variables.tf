
//NETWORK
variable "subnet_cidr" {
  description = "CIDR of the private network allowed to SSH into bastion"
  type        = string
}

variable "parent_network_id" {
  description = "ID of the parent network where the servers will be attached"
  type        = string

}

variable "server_type" {
  default = "cx23"
}

locals {
  host_ip = cidrhost(var.subnet_cidr, host_offset)
}


// e.g., for 10.50.1.20 use offset 20
variable "host_offset" {
  description = "Host offset inside subnet for Vault IP"
  type        = number
  
  validation {
    condition     = var.host_offset > 9 && var.host_offset < 26
    error_message = "Vault host offset must be in range 10-25"
  }

}
//FIREWALL

variable "vpn_subnet_cidr" {
  type = string
  description = "Wireguard VPN subnet for admin access to cluster"
}

# port 8200 from VPN subnet and private subnet
variable "vault_api_allowed_cidrs" {
  type = list(string)
  description = "from which CIDRs it is allowed to access Vault API"
  default = [var.subnet_cidr, vpn_subnet_cidr]
}

# port 22 only from VPN subnet
variable "vault_ssh_allowed_cidrs" {
  type = list(string)
  description = "from which CIDRs it is allowed to access Vault via SSH"
  default = var.vpn_subnet_cidr
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

//SERVER
variable "ssh_public_key_path" {
  type = string
}

variable "server_location" {
  type    = string
  default = "nbg1" //Nuremberg
}

variable "os_image" {
  default = "ubuntu-22.04"

}

variable "server_name" {
  description = "Name of the server to be created"
  type        = string
  
}
