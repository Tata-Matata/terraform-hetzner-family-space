variable "ssh_public_key" {
  type        = string
  description = "Admin SSH public key used for bootstrap access to bastion host"
  default     = "~/.ssh/id_ed25519.pub"
}

variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token"
  sensitive   = true
}