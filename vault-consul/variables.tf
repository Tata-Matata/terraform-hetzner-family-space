variable "hcloud_token" {
  sensitive = true
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "server_location" {
  type = string
  default = "nbg1" //Nuremberg
}


variable "vault_subnet_cidr" {
  description = "Private network CIDR for Vault and Consul"
  type        = string
  default     = "10.50.1.0/24"
}

variable "os_image" {
  default = "ubuntu-22.04"
  
}

variable "vault_ip" {
  description = "Static private IP address for the Vault server"
  type        = string
  default     = "10.50.1.11"
  
}

variable "consul_ip" {
  description = "Static private IP address for the Consul server"
  type        = string
  default     = "10.50.1.10"
}


variable "vm_type" {
  default = "cx23"
}
