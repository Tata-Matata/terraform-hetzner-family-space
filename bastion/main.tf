module "bastion" {
  source     = "../modules/bastion"
  private_network_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr
  ssh_public_key = var.ssh_public_key
}

