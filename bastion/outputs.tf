output "bastion_server_id" {
  value = module.bastion_server.server_id
}

output "bastion_public_ip" {
  value = module.bastion_server.server_public_ip
}

output "bastion_private_ip" {
  value = module.bastion_server.server_private_ip
}

output "bastion_role_label" {
  value = module.bastion_server.server_role_label
}