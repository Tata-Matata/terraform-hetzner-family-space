terraform {

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.58"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}
