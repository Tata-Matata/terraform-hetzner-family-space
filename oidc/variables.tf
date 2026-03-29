variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token"
  sensitive   = true
}

variable "host_offset_oidc" {
  description = "Host offset for OIDC server IP in the subnet"
  type        = number
  default     = 26

  validation {
    condition     = var.host_offset_oidc > 25 && var.host_offset_oidc < 30
    error_message = "Host offset must be in range 26-29"
  }
}

locals {
  # Private subnet CIDR where OIDC server will be deployed
  subnet_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr

  # CIDR of Bastion host(s)
  bastion_ip   = data.terraform_remote_state.bastion.outputs.bastion_private_ip
  bastion_cidr = "${local.bastion_ip}/32"

  # port 22 only from Bastion
  oidc_ssh_allowed_cidrs = [
    local.bastion_cidr
  ]
}