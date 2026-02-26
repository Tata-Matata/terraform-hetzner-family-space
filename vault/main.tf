module "vault_server" {
  source = "../modules/hcloud_server"
  count  = 1

  #server config
  server_name     = "vault-${count.index + 1}"
  server_location = "nbg1"
  os_image        = "ubuntu-22.04"
  server_type     = "cx23"

  #temp ssh access for Ansible from Bastion under root user. 
  # not required any more since runs under ansible user
  ssh_key_ids = []

  #network config
  public_ip_enabled = false
  // Hetzner expects here ID of the parent network
  parent_network_id = data.terraform_remote_state.core_network.outputs.parent_network_id

  //But Hetzner also expects server IP that belongs to a subnet of the network
  subnet_cidr = local.subnet_cidr

  // e.g., for 10.50.1.5 use offset 5
  host_offset = var.host_offset_vault

  //for attaching firewall
  server_labels = {
    role = "vault"
  }

  //cloud-init routing config to set default route via Bastion and configure DNS, create Ansible user with provided public key
  user_data = templatefile(
    "${path.root}/../templates/cloud-init/consul-vault-node/node.yaml.tftpl",
    {
      ansible_user_block = local.ansible_user_block
      routing_block      = local.routing_block
    }
  )
}

module "vault_firewall" {
  source = "../modules/vault_firewall"

  vault_api_allowed_cidrs = local.vault_api_allowed_cidrs
  vault_ssh_allowed_cidrs = local.vault_ssh_allowed_cidrs

}

locals {
  ansible_user_block = templatefile(
    "${path.root}/../templates/cloud-init/partials/ansible-user.yaml.tftpl",
    {
      ansible_public_key = data.terraform_remote_state.global_ssh_keys.outputs.ansible_access_public_key
    }
  )

  routing_block = templatefile(
    "${path.root}/../templates/cloud-init/partials/routing.yaml.tftpl", {}
  )
}
