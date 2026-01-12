module "bastion" {
  source     = "../modules/bastion"
  subnet_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr
  ssh_public_key_path = var.ssh_public_key_path
  subnet_id = data.terraform_remote_state.core_network.outputs.subnet_id
}

