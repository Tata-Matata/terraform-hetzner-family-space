output "consul_private_ips" {
  value = [
    for server in module.consul_server : server.server_private_ip
  ]
}


output "consul_server_ids" {
  value = [
    for server in module.consul_server : server.server_id
  ]
}

output "consul_server_labels" {
  value = [
    for server in module.consul_server : server.server_labels
  ]

}