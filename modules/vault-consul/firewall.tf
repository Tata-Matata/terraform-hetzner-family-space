//allows Vault API from private network and Consul gossip from private network
//never public

resource "hcloud_firewall" "vault_firewall" {
  name = "vault-firewall"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = ["YOUR_IP/32"]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "8200"
    source_ips = ["YOUR_IP/32"]
  }
}

resource "hcloud_firewall_attachment" "vault_fw_attach" {
  firewall_id = hcloud_firewall.vault_fw.id
  server_id   = hcloud_server.vault.id
}
