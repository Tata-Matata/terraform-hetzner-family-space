//allows Vault API from private network and Consul gossip from private network
//never public

resource "hcloud_firewall" "consul_fw" {
  name = "consul-fw"

  # SSH
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.consul_ssh_allowed_cidrs
  }

  # Consul server RPC
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "8300"
    source_ips = var.consul_cluster_cidrs
  }

  # LAN gossip (TCP)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "8301"
    source_ips = var.consul_cluster_cidrs
  }

  # LAN gossip (UDP)
  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "8301"
    source_ips = var.consul_cluster_cidrs
  }

  # HTTP API
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "8500"
    source_ips = var.consul_api_allowed_cidrs
  }
}

resource "hcloud_firewall_attachment" "consul_fw_attach" {
  firewall_id = hcloud_firewall.consul_fw.id
  server_ids  = [var.consul_server_id]

}
