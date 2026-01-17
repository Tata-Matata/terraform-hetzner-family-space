//Bastion server exposes WireGuard VPN (UDP 51820)
//Restricts SSH from only VPN subnet

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
    source_ips = [var.vpn_subnet_cidr]
  }

  apply_to {
    label_selector = "role=bastion"
  }
}

