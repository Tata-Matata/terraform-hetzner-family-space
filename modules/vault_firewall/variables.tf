
# CIDR of the private network that is allowed to access Vault

# port 8200 from VPN subnet and private subnet
variable "vault_api_allowed_cidrs" {
  type        = list(string)
  description = "from which CIDRs it is allowed to access Vault API"
}

# port 22 only from VPN subnet
variable "vault_ssh_allowed_cidrs" {
  type        = list(string)
  description = "from which CIDRs it is allowed to access Vault via SSH"
}

