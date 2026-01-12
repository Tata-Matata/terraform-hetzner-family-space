data "terraform_remote_state" "network" {
  //CHANGE to Terraform Cloud 
  backend = "local"

  config = {
    path = "../core-network/terraform.tfstate"
  }
}

/* 
data "terraform_remote_state" "tf_state_network" {
 
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "tatamatata-org"

    workspaces = {
      name = "core-network"
    }
  }
} */


module "bastion" {
  source     = "../modules/bastion_vm"
  //CHANGE to Terraform Cloud
  network_id = data.terraform_remote_state.network.outputs.id
}

