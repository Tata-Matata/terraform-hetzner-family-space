output "server_id" {
  value = hcloud_server.server.id
}

output "server_public_ip" {
  value = hcloud_server.server.ipv4_address
}

output "server_private_ip" {
  value = one(hcloud_server.server.network).ip
}

output "server_labels" {
  value = [for k, v in var.server_labels : "${k}=${v}"]
}