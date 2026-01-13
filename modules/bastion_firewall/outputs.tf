output "bastion_public_ip" {
  value = hcloud_server.bastion.ipv4_address
}

output "bastion_private_ip" {
  value = one(hcloud_server.bastion.network).ip
}
