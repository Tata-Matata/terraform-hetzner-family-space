//passed from root module
variable "ssh_public_key_path" {
  description = "SSH public key installed on the bastion for initial access"
}

variable "subnet_cidr" {
  description = "CIDR of the private network allowed to SSH into bastion"
  type        = string
}

variable "subnet_id" {
  description = "ID of the private network allowed to SSH into bastion"
  type        = string
}

variable "server_type" {
  default = "cx23"
}

variable "bastion_host_offset" {
  description = "Host offset inside subnet for bastion IP"
  type        = number
  // e.g., for 10.50.1.5 use offset 5
  default = 5

  validation {
    condition     = var.bastion_host_offset > 1
    error_message = "Bastion host offset must be > 1"
  }

}

locals {
  bastion_private_ip = cidrhost(var.subnet_cidr, var.bastion_host_offset)
}

variable "location" {
  default = "nbg1"
}

variable "os_image" {
  default = "ubuntu-22.04"
}


