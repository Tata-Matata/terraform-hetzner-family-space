
//private subnet with cluster nodes
variable "subnet_cidr" {
  description = "CIDR of the private network allowed to SSH into bastion"
  type        = string
}

//VPN subnet for admin access
variable "vpn_subnet_cidr" {
  type = string
  description = "Wireguard VPN subnet for admin access to cluster"
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

variable "consul_server_id" {
  description = "ID of the Consul server to attach the firewall to"
  type        = string
  
}