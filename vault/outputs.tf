output "vault_private_ip" {
  value = hcloud_server.vault.network[0].ip
}

output "consul_private_ip" {
  value = hcloud_server.consul.network[0].ip
}
