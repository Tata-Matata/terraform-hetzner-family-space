variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token"
  sensitive   = true
}

locals {
  # Private subnet CIDR where Vault server will be deployed
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

  # port 8200 from private subnet
  vault_api_allowed_cidrs = local.machine_cidrs

  # port 22 only from Bastion
  vault_ssh_allowed_cidrs = local.human_entry_cidrs
}

# Offset for Vault server IP in the private subnet
variable "host_offset_vault" {
  description = "Host offset for Vault server IP in the subnet"
  type        = number
  default     = 20

  validation {
    condition     = var.host_offset_vault > 19 && var.host_offset_vault < 26
    error_message = "Host offset must be in range 20-25"
  }
}


