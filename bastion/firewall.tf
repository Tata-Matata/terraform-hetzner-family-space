resource "hcloud_firewall" "bastion_fw" {
  name = "bastion-fw"

  # WireGuard VPN (public)
  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "51820"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # SSH only from private network
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [var.private_network_cidr]
  }
}
