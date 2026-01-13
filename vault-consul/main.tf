module "vault" {
  source = "../modules/vault-consul"

  server_name = "vault"

  subnet_cidr         = data.terraform_remote_state.core_network.outputs.subnet_cidr
  ssh_public_key_path = var.ssh_public_key_path
  server_location     = "nbg1"
  host_offset         = 10
  os_image            = "ubuntu-22.04"
  server_type         = "cx23"
  parent_network_id   = data.terraform_remote_state.core_network.outputs.parent_network_id

  vault_api_allowed_cidrs = [
    data.terraform_remote_state.core.outputs.private_subnet_cidr, # private subnet for cluster
    var.vpn_subnet_cidr # Wireguard VPN subnet
  ]


  vault_ssh_allowed_cidrs = [
    var.vpn_subnet_cidr
  ]

}

module "consul" {
  source = "../modules/vault-consul"

  server_name = "consul"

  subnet_cidr         = data.terraform_remote_state.core_network.outputs.subnet_cidr
  ssh_public_key_path = var.ssh_public_key_path
  server_location     = "nbg1"
  host_offset         = 20
  os_image            = "ubuntu-22.04"
  server_type         = "cx23"
  parent_network_id   = data.terraform_remote_state.core_network.outputs.parent_network_id

   vault_api_allowed_cidrs = [
    data.terraform_remote_state.core.outputs.private_subnet_cidr, # private subnet for cluster
    var.vpn_subnet_cidr # Wireguard VPN subnet
  ]

  vault_ssh_allowed_cidrs = [
    var.vpn_subnet_cidr
  ]


}

