module "vault_server" {
  source = "../modules/hcloud_server"

  #server config
  server_name     = "vault"
  server_location = "nbg1"
  os_image        = "ubuntu-22.04"
  server_type     = "cx23"

  #temp admin access
  ssh_public_key_path = var.ssh_public_key_path

  #network config
  public_ip_enabled   = false
  // Hetzner expects here ID of the parent network
  parent_network_id = data.terraform_remote_state.core_network.outputs.parent_network_id

  //But Hetzner also expects server IP that belongs to a subnet of the network
  subnet_cidr = var.subnet_cidr

  // e.g., for 10.50.1.5 use offset 5
  host_offset = var.host_offset_vault

}

module "vault_firewall" {
  source          = "../modules/vault_firewall"

  vault_api_allowed_cidrs = var.vault_api_allowed_cidrs
  vault_ssh_allowed_cidrs = var.vault_ssh_allowed_cidrs

  vault_server_id = module.vault_server.server_id
}

