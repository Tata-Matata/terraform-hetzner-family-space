resource "hcloud_ssh_key" "admin" {
  name       = "vault-consul-ssh-access-key"
  public_key = file(var.ssh_public_key_path)
}

resource "hcloud_server" "consul" {
  name        = "consul-server"
  image       = var.os_image
  server_type = var.vm_type
  location    = var.server_location

  ssh_keys = [hcloud_ssh_key.admin.id]

  network {
    network_id = hcloud_network.vault_net.id
    ip         = var.consul_ip
  }

  //remove in case of recovery
  lifecycle {
    prevent_destroy = true
  }
}

resource "hcloud_server" "vault" {
  name        = "vault-server"
  image       = var.os_image
  server_type = var.vm_type
  location    = var.server_location

  ssh_keys = [hcloud_ssh_key.admin.id]

  network {
    network_id = hcloud_network.vault_net.id
    ip         = var.vault_ip
  }

  //remove in case of recovery
  lifecycle {
    prevent_destroy = true
  }
}
