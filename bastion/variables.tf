variable "hcloud_token" {
  sensitive = true
}

variable "ssh_public_key_path" {
  description = "Admin SSH public key used for bootstrap access to bastion host"
  default = "~/.ssh/id_ed25519.pub"
}


