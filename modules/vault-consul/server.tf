resource "hcloud_ssh_key" "admin" {
  name       = "temp-ssh-access-key"
  public_key = file(var.ssh_public_key_path)
}

resource "hcloud_server" "vault-consul-server"{
  name        = var.server_name
  image       = var.os_image
  server_type = var.server_type
  location    = var.server_location

  ssh_keys = [hcloud_ssh_key.admin.id]

   network {
    // Hetzner expects here ID of the parent network
    network_id = var.parent_network_id

    //Hetzner expects here IP that belongs to a subnet of the network
    ip         = local.host_ip
  }

  //remove in case of recovery
  lifecycle {
    prevent_destroy = true
  }
}





