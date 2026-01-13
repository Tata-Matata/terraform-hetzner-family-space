module "bastion_server" {
  source     = "../modules/hcloud_server"

  #server config
  server_name = "bastion"
  server_location = "nbg1"
  os_image = "ubuntu-22.04"
  server_type = "cx23"

  #temp admin access
  ssh_public_key_path = var.ssh_public_key_path

  #network config

  // Hetzner expects here ID of the parent network
  parent_network_id = data.terraform_remote_state.core_network.outputs.parent_network_id

  //But Hetzner also expects server IP that belongs to a subnet of the network
  subnet_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr

  // e.g., for 10.50.1.5 use offset 5
  host_offset = 5
}

module "bastion_firewall" {
  source = "../modules/bastion_firewall"

  #attach to bastion server
  bastion_server_id    = module.bastion_server.server_id
  subnet_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr
}


