output "vault_server_id" {
  value = module.vault_server.server_id
}


output "vault_private_ip" {
  value = module.vault_server.server_private_ip
}

output "vault_role_label" {
  value = module.vault_server.server_role_label

}