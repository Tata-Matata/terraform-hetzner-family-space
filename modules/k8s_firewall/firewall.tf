resource "hcloud_firewall" "k8s-common-firewall" {
  name = "k8s-common-firewall"

  apply_to {
    label_selector = "role=k8s"
  }
  // SSH access
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.k8s_ssh_port
    source_ips = var.k8s_ssh_allowed_cidrs
  }

  //Kubelet API
  // private network for K8s nodes + humans / CI via WireGuard VPN
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.k8s_kubelet_port
    source_ips = var.k8s_kubelet_api_allowed_cidrs
  }

  # Calico VXLAN overlay
  rule {
    direction  = "in"
    protocol   = "udp"
    port       = var.k8s_calico_port
    source_ips = var.k8s_calico_vxlan_allowed_cidrs
  }
}

resource "hcloud_firewall" "k8s-controlplane-firewall" {
  name = "k8s-controlplane-firewall"

  apply_to {
    label_selector = "tier=controlplane"
  }

  // Kubernetes API server
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = var.k8s_api_port
    source_ips = var.k8s_api_allowed_cidrs
  }
}

