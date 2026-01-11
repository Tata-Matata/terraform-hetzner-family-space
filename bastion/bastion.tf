resource "hcloud_server" "bastion" {
  name        = "bastion-wg"
  image       = "ubuntu-22.04"
  server_type = var.server_type
  location    = var.location

  ssh_keys = [hcloud_ssh_key.admin.id]

  # Public networking enabled (VPN endpoint)
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  # Private network attachment
  network {
    network_id = hcloud_network.private.id
    ip         = var.bastion_private_ip
  }

  firewall_ids = [hcloud_firewall.bastion_fw.id]

  lifecycle {
    prevent_destroy = true
  }
}

