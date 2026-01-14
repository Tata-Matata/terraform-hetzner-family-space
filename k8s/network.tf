resource "hcloud_network" "k8s" {
  name     = "k8s-net"
  ip_range = var.cluster_private_cidr
}

resource "hcloud_network_subnet" "k8s" {
  network_id   = hcloud_network.k8s.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

