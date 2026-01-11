resource "hcloud_network" "vault_net" {
  name     = "vault-net"
  ip_range = "10.50.0.0/16"
}

resource "hcloud_network_subnet" "vault_subnet" {
  network_id = hcloud_network.vault_net.id
  type       = "cloud"
  network_zone = "eu-central"
  ip_range  = var.vault_subnet_cidr
}

