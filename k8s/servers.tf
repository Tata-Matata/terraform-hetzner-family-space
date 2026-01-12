resource "hcloud_ssh_key" "main" {
  name       = "k8s-admin"
  public_key = file(var.ssh_public_key_path)
}

resource "hcloud_server" "control_plane" {
  name        = "k8s-master-1"
  image       = var.os_image
  server_type = var.control_plane_type
  location    = var.server_location
  ssh_keys    = [hcloud_ssh_key.main.id]

  firewall_ids = [hcloud_firewall.control_plane.id]

  network {
    network_id = hcloud_network.k8s.id
  }

  labels = {
    role = "control-plane"
  }
}
resource "hcloud_server" "worker" {
  count       = 2
  name        = "k8s-worker-${count.index + 1}"
  image       = var.os_image 
  server_type = var.worker_type
  location    = var.server_location
  ssh_keys    = [hcloud_ssh_key.main.id]

  firewall_ids = [hcloud_firewall.worker.id]

  network {
    network_id = hcloud_network.k8s.id
  }

  labels = {
    role = "worker"
  }
}
