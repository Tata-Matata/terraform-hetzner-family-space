variable "subnet_cidr" {
  description = "CIDR of the private subnet accessible from bastion"
  type        = string
  
}

variable "bastion_server_id" {
  description = "ID of the bastion server to attach the firewall to"
  type        = string
  
}



