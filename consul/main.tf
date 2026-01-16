module "consul_server" {
  source = "../modules/hcloud_server"

  #server config
  server_name     = "consul"
  server_location = "nbg1"
  os_image        = "ubuntu-22.04"
  server_type     = "cx23"

  #temp admin access
  ssh_key_ids = [data.hcloud_ssh_key.admin.id]

  #network config

  public_ip_enabled = false

  // Hetzner expects here ID of the parent network
  parent_network_id = data.terraform_remote_state.core_network.outputs.parent_network_id

  //But Hetzner also expects server IP that belongs to a subnet of the network
  subnet_cidr = local.subnet_cidr

  // e.g., for 10.50.1.5 use offset 5
  host_offset = var.host_offset_consul

  //for attaching firewall
  server_labels = {
    role = "consul"
  }
}

module "consul_firewall" {
  source = "../modules/consul_firewall"

  #firewall rules
  consul_ssh_allowed_cidrs = local.consul_ssh_allowed_cidrs
  consul_cluster_cidrs     = local.consul_cluster_cidrs
  consul_api_allowed_cidrs = local.consul_api_allowed_cidrs

}
