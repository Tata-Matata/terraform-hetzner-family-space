variable "hcloud_token" {
  sensitive = true
}

variable "ssh_public_key_path" {
  description = "Admin SSH public key used for bootstrap access to bastion host"
  default = "~/.ssh/id_ed25519.pub"
}


variable "host_offset_bastion" {
  description = "Host offset for Bastion server IP in the subnet"
  type        = number
  default     = 5 

  validation {
    condition     = var.host_offset_bastion > 0 && var.host_offset_bastion < 10
    error_message = "Host offset must be in range 1-9"
  }
  
}