variable "hcloud_token" {
  sensitive = true
}

variable "ssh_public_key" {
  description = "Admin SSH public key (temporary, for bootstrap)"
}

variable "location" {
  default = "fsn1"
}

variable "server_type" {
  default = "cx23"
}

variable "private_network_cidr" {
  default = "10.50.0.0/16"
}

variable "bastion_private_ip" {
  default = "10.50.1.5"
}


