

# port 22 only from VPN subnet
variable "k8s_ssh_allowed_cidrs" {
  type        = list(string)
  description = "from which CIDRs it is allowed to access K8s nodes via SSH"

}

# port 10250 (Kubelet HTTP API) from private subnet
# used by Vault, automation
variable "k8s_kubelet_api_allowed_cidrs" {
  type        = list(string)
  description = "from which CIDRs it is allowed to access Kubelet HTTP API"

}

# port 6443 (HTTP API) 
# private network for K8s nodes + humans / CI via WireGuard VPN
variable "k8s_api_allowed_cidrs" {
  type        = list(string)
  description = "from which CIDRs it is allowed to access K8s HTTP API"

}

# port 4789 UDP (Calico VXLAN mode) from private subnet
variable "k8s_calico_vxlan_allowed_cidrs" {
  type        = list(string)
  description = "from which CIDRs it is allowed to access K8s Calico VXLAN"

}


//PORTS
variable "k8s_ssh_port" {
  type        = number
  description = "SSH port for K8s nodes"
  default     = 22
}

variable "k8s_api_port" {
  type        = number
  description = "K8s API server port"
  default     = 6443

}

variable "k8s_kubelet_port" {
  type        = number
  description = "Kubelet HTTP API port"
  default     = 10250

}

variable "k8s_calico_port" {
  type        = number
  description = "K8s Calico VXLAN port"
  default     = 4789

}


