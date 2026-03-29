resource "hcloud_firewall" "oidc_fw" {
  name = "oidc-fw"

  # SSH - only from bastion / VPN entrypoint host
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.oidc_ssh_allowed_cidrs
  }

  apply_to {
    label_selector = "role=oidc"
  }
}