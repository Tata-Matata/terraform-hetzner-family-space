resource "hcloud_firewall" "control_plane" {
  name = "k8s-control-plane"

  # SSH
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # Kubernetes API server
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "6443"
    source_ips = [var.cluster_private_cidr]
  }

  # etcd (future HA-safe)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "2379-2380"
    source_ips = [var.cluster_private_cidr]
  }
}
resource "hcloud_firewall" "worker" {
  name = "k8s-worker"

  # SSH
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # NodePort range (future ingress)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "30000-32767"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "control_plane" {
  name        = "k8s-master-1"
  image       = "ubuntu-22.04"
  server_type = var.control_plane_type
  location    = "nbg1"
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
  image       = "ubuntu-22.04"
  server_type = var.worker_type
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.main.id]

  firewall_ids = [hcloud_firewall.worker.id]

  network {
    network_id = hcloud_network.k8s.id
  }

  labels = {
    role = "worker"
  }
}

