variable "hcloud_token" {
  type      = string
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

variable "os_image" {
  type    = string
  default = "ubuntu-22.04"
  
}

variable "cluster_private_cidr" {
  description = "Private network CIDR for the Kubernetes cluster"
  type        = string
  default     = "10.0.0.0/16"
}

variable "control_plane_type" {
  default = "cx23"
}

variable "worker_type" {
  default = "cx23"
}

