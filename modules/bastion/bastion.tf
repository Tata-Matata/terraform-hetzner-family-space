resource "hcloud_server" "bastion" {
  name        = "bastion-wireguard"
  image       = var.os_image
  server_type = var.server_type
  location    = var.location

  ssh_keys = [hcloud_ssh_key.bastion_init_access.id]

  # Public networking enabled (VPN endpoint)
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  # Private network attachment
  network {
    network_id = var.subnet_id
    ip         = local.bastion_private_ip
  }

  # attached firewall rules
  firewall_ids = [hcloud_firewall.bastion_fw.id]

  lifecycle {
    prevent_destroy = true
  }
}

resource "hcloud_ssh_key" "bastion_init_access" {
  name       = "bastion-init-access-key"
  public_key = file(var.ssh_public_key_path)
}

