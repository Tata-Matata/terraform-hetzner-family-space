output "oidc_private_ips" {
  value = [
    for server in module.oidc_server : server.server_private_ip
  ]
}

output "oidc_server_ids" {
  value = [
    for server in module.oidc_server : server.server_id
  ]
}

output "oidc_server_labels" {
  value = [
    for server in module.oidc_server : server.server_labels
  ]
}