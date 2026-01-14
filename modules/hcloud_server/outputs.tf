output "server_id" {
  value = hcloud_server.server.id
}

output "server_public_ip" {
  value = hcloud_server.server.ipv4_address
}

output "server_private_ip" {
  value = one(hcloud_server.server.network).ip
}

output "server_role_label" {
  value = hcloud_server.server.labels["role"]
}