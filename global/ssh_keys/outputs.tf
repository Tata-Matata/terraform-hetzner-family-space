output "ansible_access_public_key" {
  description = "value to add to new servers' authorized_keys for Ansible access via ssh from Bastion"
  value       = hcloud_ssh_key.hcloud_ansible_access_pub_ssh_key.id
}

output "ansible_access_private_key" {
  description = "authentication  to private servers for Ansible ssh running from Bastion"
  value       = tls_private_key.bootstrap_ansible.private_key_openssh
  sensitive   = true
}
