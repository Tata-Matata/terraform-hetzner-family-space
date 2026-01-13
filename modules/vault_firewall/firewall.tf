//allows Vault API from private network and Consul gossip from private network
//never public

resource "hcloud_firewall" "vault_fw" {
  name = "vault-fw"

  # SSH – only from bastion / VPN
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.vault_ssh_allowed_cidrs
  }

  # Vault API – private only
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "8200"
    source_ips = var.vault_api_allowed_cidrs
  }
}

resource "hcloud_firewall_attachment" "vault_fw_attach" {
  firewall_id = hcloud_firewall.vault_fw.id
  server_ids  = [var.vault_server_id]

}
