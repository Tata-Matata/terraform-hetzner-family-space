/* 
data "terraform_remote_state" "core_network" {
  backend = "remote" # Terraform Cloud
  config = {
    organization = "your-org"
    workspaces = {
      name = "core-network"
    }
  }
} 
*/

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

data "terraform_remote_state" "core_network" {
  backend = "local" # Local backend for testing
  config = {
    path = "../core-network/terraform.tfstate"
  }
}