resource "hcloud_ssh_key" "admin" {
  name       = "admin-bootstrap-key"
  public_key = file(var.ssh_public_key)
}
