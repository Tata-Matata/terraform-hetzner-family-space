

# port 22 only from VPN subnet
variable "consul_ssh_allowed_cidrs" {
  type        = list(string)
  description = "from which CIDRs it is allowed to access Consul via SSH"

}

# port 8300 (Consul Servers talking to each other)
# 8301 (Serf gossip protocol used by Consul server and agents) 
# only from private subnet
variable "consul_cluster_cidrs" {
  type        = list(string)
  description = "from which CIDRs it is allowed to access Consul Server"

}

# port 8500 (HTTP API) from private subnet and VPN
# used by Vault, automation
variable "consul_api_allowed_cidrs" {
  type        = list(string)
  description = "from which CIDRs it is allowed to access Consul HTTP API"

}

variable "consul_server_id" {
  description = "ID of the Consul server to attach the firewall to"
  type        = string

}
