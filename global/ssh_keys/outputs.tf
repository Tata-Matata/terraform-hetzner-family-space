output "ansible_access_public_key" {
  description = "to be added to authorized_keys on Consul and Vault servers for Ansible access via ssh from Bastion"
  value       = hcloud_ssh_key.hcloud_ansible_access_pub_ssh_key.id

  precondition {
    condition     = length(trimspace(hcloud_ssh_key.hcloud_ansible_access_pub_ssh_key.id)) > 0
    error_message = "Ansible public key must not be empty."
  }
}

output "ansible_access_private_key" {
  description = "authentication  to private servers for Ansible ssh running from Bastion"
  value       = tls_private_key.bootstrap_ansible.private_key_openssh
  sensitive   = true

  precondition {
    condition     = length(trimspace(tls_private_key.bootstrap_ansible.private_key_openssh)) > 0
    error_message = "Ansible private key must not be empty."
  }
}

output "admin_access_public_key" {
  description = "to be added to authorized_keys on Bastion server for initial admin access via ssh, will be removed after Ansible access is working"
  value       = hcloud_ssh_key.admin.public_key
  sensitive   = true

  precondition {
    condition = can(regex(
      "^ssh-ed25519\\s+[A-Za-z0-9+/=]+",
      trimspace(hcloud_ssh_key.admin.public_key)
    ))
    error_message = "Admin public key must be a valid SSH public key string"
  }
}
