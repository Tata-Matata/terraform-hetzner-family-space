output "consul_private_ip" {
  value = module.consul_server.server_private_ip
}

output "consul_server_id" {
  value = module.consul_server.server_id
}

output "consul_server_role_label" {
  value = module.consul_server.server_role_label

}