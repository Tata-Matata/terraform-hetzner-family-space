variable "oidc_ssh_allowed_cidrs" {
  type        = list(string)
  description = "From which CIDRs it is allowed to access the OIDC host via SSH"
}