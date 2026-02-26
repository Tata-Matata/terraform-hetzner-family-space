//for logging into Bastion, private key is local, 
//public key is registered with Hetzner Cloud and injected into Bastion server
resource "hcloud_ssh_key" "admin" {
  name       = "admin-bootstrap-key"
  public_key = file(var.ssh_public_key)
}

//for Ansible to login into newly created servers from Bastion
//this resource is Terraform native tls provider
resource "tls_private_key" "bootstrap_ansible" {
  algorithm = "ED25519"
}

//this resource is derived from tls_private_key above to register the public key with Hetzner Cloud
//and then inject it into newly created servers
resource "hcloud_ssh_key" "hcloud_ansible_access_pub_ssh_key" {
  name       = "bootstrap-ansible"
  public_key = tls_private_key.bootstrap_ansible.public_key_openssh
}

