//Bastion server exposes WireGuard VPN (UDP 51820)
//Restricts SSH to only private network (VPN subnet)

resource "hcloud_firewall" "bastion_fw" {
  name = "bastion-fw"

  # to login into WireGuard VPN (public)
  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "51820"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # SSH only from private network (VPN subnet)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [var.subnet_cidr]
  }
}

resource "hcloud_firewall_attachment" "bastion_fw_attach" {
  firewall_id = hcloud_firewall.bastion_fw.id
  server_ids  = [var.bastion_server_id]

}
