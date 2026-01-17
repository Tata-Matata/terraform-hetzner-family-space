variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token"
  sensitive   = true
}


variable "min_ip" {
  description = "Minimum IP address in the subnet"
  type        = number
  default     = 30
}

variable "max_ip" {
  description = "Maximum IP address in the subnet"
  type        = number
  default     = 60

}

locals {

  max_host_offset_worker = var.max_ip
  min_host_offset_worker = var.min_ip + 11

  max_host_offset_controlplane = var.max_ip - 20
  min_host_offset_controlplane = var.min_ip
}


variable "host_offset_k8s_controlplane" {

  description = "Host offset for K8s controlplane node IP in the subnet"
  type        = number
  default     = 30

  validation {
    condition = alltrue([
      var.host_offset_k8s_controlplane >= local.min_host_offset_controlplane,
      var.host_offset_k8s_controlplane <= local.max_host_offset_controlplane
    ])

    error_message = "Host offset must be in range ${local.min_host_offset_controlplane}-${local.max_host_offset_controlplane} to avoid IP conflicts in the subnet."
  }

}

variable "host_offset_k8s_worker" {

  description = "Host offset for K8s worker node IP in the subnet"
  type        = number
  default     = 41

  validation {
    condition = alltrue([
      var.host_offset_k8s_worker >= local.min_host_offset_worker,
      var.host_offset_k8s_worker <= local.max_host_offset_worker
    ])

    error_message = "Host offset must be in range ${local.min_host_offset_worker}-${local.max_host_offset_worker} to avoid IP conflicts in the subnet."
  }

}

// FIREWALL
locals {
  # CIDR of the private subnet (machine-to-machine)
  subnet_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr

  # CIDR of Bastion host(s)
  bastion_ip   = data.terraform_remote_state.bastion.outputs.bastion_private_ip
  bastion_cidr = "${local.bastion_ip}/32"


  # Human entry point (ssh from Bastion only)
  human_entry_cidrs = [
    local.bastion_cidr
  ]

  # Internal service communication
  machine_cidrs = [
    local.subnet_cidr
  ]

  # port 22 human access only from Bastion
  k8s_ssh_allowed_cidrs = local.human_entry_cidrs

  # port 10250 (Kubelet HTTP API) from machine CIDRs only
  k8s_kubelet_api_allowed_cidrs = local.machine_cidrs

  # port 6443 (HTTP API) 
  # from machine CIDRs + Bastion for admin access via kubectl
  k8s_api_allowed_cidrs = concat(local.machine_cidrs, local.human_entry_cidrs)

  # port 4789 UDP (Calico VXLAN mode) from private subnet
  k8s_calico_vxlan_allowed_cidrs = local.machine_cidrs

}

//HOST
variable "os_image" {
  type        = string
  description = "Operating system image for the server"
  default     = "ubuntu-22.04"
}

variable "hetzner_server_type" {
  type        = string
  description = "Hetzner server type for K8s nodes"
  default     = "cx23"

}

variable "hetzner_server_location" {
  type        = string
  description = "Hetzner server location for K8s nodes"
  default     = "nbg1"

}

variable "common_k8s_node_label" {
  type        = string
  description = "Common label for all K8s nodes"
  default     = "k8s"

}