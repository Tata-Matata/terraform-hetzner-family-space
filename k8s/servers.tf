resource "hcloud_ssh_key" "main" {
  name       = "k8s-admin"
  public_key = file(var.ssh_public_key_path)
}

