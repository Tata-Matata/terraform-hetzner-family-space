module "k8s_controlplane_server" {
  source = "../modules/hcloud_server"

  #server config
  count           = 1 // will grow later for HA
  server_name     = "k8s-controlplane-${count.index + 1}"
  server_location = var.hetzner_server_location
  os_image        = var.os_image
  server_type     = var.hetzner_server_type

  #temp admin access
  ssh_key_ids = [data.hcloud_ssh_key.admin.id]

  #network config
  //enable public IP only for bastion 
  // k8s nodes will be private only
  public_ip_enabled = false

  // Hetzner expects here ID of the parent network
  parent_network_id = data.terraform_remote_state.core_network.outputs.parent_network_id

  //But Hetzner also expects server IP that belongs to a subnet of the network
  subnet_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr

  // e.g., for 10.50.1.5 use offset 5
  host_offset = var.host_offset_k8s_controlplane + count.index

  //for attaching firewall
  server_labels = {
    role = var.common_k8s_node_label
    tier = "controlplane"
  }
}


module "k8s_worker_server" {
  source = "../modules/hcloud_server"

  #server config
  count           = 1
  server_name     = "k8s-worker-${count.index + 1}"
  server_location = var.hetzner_server_location
  os_image        = var.os_image
  server_type     = var.hetzner_server_type

  #temp admin access
  ssh_key_ids = [data.hcloud_ssh_key.admin.id]

  #network config
  //enable public IP only for bastion 
  // k8s nodes will be private only
  public_ip_enabled = false

  // Hetzner expects here ID of the parent network
  parent_network_id = data.terraform_remote_state.core_network.outputs.parent_network_id

  //But Hetzner also expects server IP that belongs to a subnet of the network
  subnet_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr

  // e.g., for 10.50.1.5 use offset 5
  host_offset = var.host_offset_k8s_worker + count.index

  //for attaching firewall
  server_labels = {
    role = var.common_k8s_node_label
    tier = "worker"
  }
}

module "k8s_controlplane_firewall" {
  source = "../modules/k8s_firewall"

  #firewall rules
  k8s_ssh_allowed_cidrs          = local.k8s_ssh_allowed_cidrs
  k8s_api_allowed_cidrs          = local.k8s_api_allowed_cidrs
  k8s_kubelet_api_allowed_cidrs  = local.k8s_kubelet_api_allowed_cidrs
  k8s_calico_vxlan_allowed_cidrs = local.k8s_calico_vxlan_allowed_cidrs
}


