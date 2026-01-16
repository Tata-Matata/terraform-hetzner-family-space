resource "hcloud_server" "server" {
  name        = var.server_name
  image       = var.os_image
  server_type = var.server_type
  location    = var.server_location

  ssh_keys = var.ssh_key_ids

  public_net {
    ipv4_enabled = var.public_ip_enabled
    ipv6_enabled = false
  }

  network {
    // Hetzner expects here ID of the parent network
    network_id = var.parent_network_id

    //Hetzner expects here IP that belongs to a subnet of the network
    ip = local.host_ip
  }

  lifecycle {
    precondition {
      condition     = length(var.ssh_key_ids) > 0
      error_message = "Required SSH key missing. Apply global/ssh-keys first."
    }
  }

  /* //remove in case of recovery
  lifecycle {
    prevent_destroy = true
  } */
  labels = var.server_labels
}





