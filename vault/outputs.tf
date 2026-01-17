output "vault_server_ids" {
  value = [
    for server in module.vault_server : server.server_id
  ]
}


output "vault_private_ips" {
  value = [
    for server in module.vault_server : server.server_private_ip
  ]
}

output "vault_server_labels" {
  value = [
    for server in module.vault_server : server.server_labels
  ]

}