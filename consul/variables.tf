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

locals {
  # CIDR of the private subnet
  subnet_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr

  # CIDR of Bastion host(s)
  bastion_ip   = data.terraform_remote_state.bastion.outputs.bastion_private_ip
  bastion_cidr = "${local.bastion_ip}/32"

  # Human entry point (ssh from Bastion only)
  human_entry_cidrs = [
    local.bastion_cidr
  ]

  # Internal service communication
  machine_cidrs = [
    local.subnet_cidr
  ]

  # port 22 only from bastion
  consul_ssh_allowed_cidrs = local.human_entry_cidrs

  # port 8300 (Consul Servers talking to each other)
  # 8301 (Serf gossip protocol used by Consul server and agents) 
  # only from private subnet
  consul_cluster_cidrs = local.machine_cidrs

  # port 8500 (HTTP API) from private subnet
  consul_api_allowed_cidrs = local.machine_cidrs


}



