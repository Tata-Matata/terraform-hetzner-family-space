variable "private_network_cidr" {
  default = "10.50.0.0/16"
}

variable "network_zone" {
  description = "Hetzner Cloud Network Zone"
  default     = "eu-central"

}

//part of private_network_cidr
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "10.50.1.0/24"
}

