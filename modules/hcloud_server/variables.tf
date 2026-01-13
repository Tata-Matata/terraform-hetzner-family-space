
//NETWORK
variable "subnet_cidr" {
  description = "CIDR of the private network allowed to SSH into bastion"
  type        = string
}

variable "parent_network_id" {
  description = "ID of the parent network where the servers will be attached"
  type        = string

}

variable "server_type" {
  default = "cx23"
}

locals {
  host_ip = cidrhost(var.subnet_cidr, host_offset)
}


// e.g., for 10.50.1.20 use offset 20
variable "host_offset" {
  description = "Host offset inside subnet for Vault IP"
  type        = number
  
  validation {
    condition     = var.host_offset > 9 && var.host_offset < 26
    error_message = "Vault host offset must be in range 10-25"
  }

}

//SERVER
variable "ssh_public_key_path" {
  type = string
}

variable "server_location" {
  type    = string
  default = "nbg1" //Nuremberg
}

variable "os_image" {
  default = "ubuntu-22.04"

}

variable "server_name" {
  description = "Name of the server to be created"
  type        = string
  
}
