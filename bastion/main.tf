module "bastion" {
  source     = "../modules/bastion"
  subnet_cidr = data.terraform_remote_state.core_network.outputs.subnet_cidr
  ssh_public_key = var.ssh_public_key
  subnet_id = data.terraform_remote_state.core_network.outputs.subnet_id
}

