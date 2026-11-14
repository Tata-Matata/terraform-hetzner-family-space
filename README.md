# terraform-hetzner-family-space

Terraform code that provisions a small platform on [Hetzner Cloud](https://www.hetzner.com/cloud): a bastion host, a Consul server, a Vault server and a Kubernetes cluster (control plane + worker). It also generates an Ansible inventory for configuring the servers afterwards (see [ansible-family-space](https://github.com/Tata-Matata/ansible-family-space)).

## Architecture

```
                 Internet
                    │  UDP 51820 (WireGuard)
              ┌─────▼─────┐
              │  bastion  │  only server with a public IPv4
              └─────┬─────┘  default gateway for private egress
                    │
   private network 10.50.0.0/16, subnet 10.50.1.0/24
        │               │                │
   ┌────▼────┐     ┌────▼────┐     ┌─────▼──────────────┐
   │ consul  │     │  vault  │     │ k8s control plane  │
   └─────────┘     └─────────┘     │ k8s worker         │
                                   └────────────────────┘
```

- **Bastion** is the only host with a public IP. It exposes WireGuard (UDP 51820); SSH is allowed only from the VPN subnet. Via cloud-init it installs `ansible-core`, receives the Ansible SSH private key and clones the Ansible repo.
- **Private servers** (Consul, Vault, Kubernetes) have no public IP. Their SSH is allowed only from the bastion, and egress goes through the bastion via a `hcloud_network_route` (`0.0.0.0/0` → bastion). Cloud-init sets up the matching route and DNS.
- **Firewalls** are Hetzner Cloud firewalls attached by label selector (`role=...`, `tier=...`).

### Static IP layout (host offsets in `10.50.1.0/24`)

| Server               | Default offset | Allowed range |
|----------------------|----------------|---------------|
| bastion              | 5              | 1–10          |
| consul               | 10             | 10–15         |
| vault                | 20             | 20–25         |
| k8s control plane    | 30             | 30–40         |
| k8s worker           | 41             | 41–60         |

### Firewall rules

| Target        | Ports                                               | Sources                       |
|---------------|-----------------------------------------------------|-------------------------------|
| bastion       | UDP 51820 / TCP 22                                  | anywhere / VPN subnet         |
| consul        | TCP 22 / TCP 8300, 8301, UDP 8301, TCP 8500         | bastion / private subnet      |
| vault         | TCP 22 / TCP 8200                                   | bastion / private subnet      |
| k8s (all)     | TCP 22 / TCP 10250 / UDP 4789 (Calico VXLAN)        | bastion / private subnet      |
| k8s control plane | TCP 6443                                        | private subnet + bastion      |

## Repository layout

| Path                | Purpose |
|---------------------|---------|
| [global/ssh_keys](global/ssh_keys)     | Admin bootstrap SSH key (uploaded to Hetzner) and a generated ED25519 key pair for Ansible |
| [core_network](core_network)           | Private network and subnet |
| [bastion](bastion)                     | Bastion server, firewall and egress route |
| [consul](consul)                       | Consul server(s) and firewall |
| [vault](vault)                         | Vault server(s) and firewall |
| [k8s](k8s)                             | Kubernetes control plane and worker servers, firewalls |
| [ansible_inventory](ansible_inventory) | Renders the Ansible inventory from the other roots' outputs |
| [modules](modules)                     | Reusable modules: `core_network`, `hcloud_server`, and one firewall module per service |
| [templates](templates)                 | Shared cloud-init templates |

Each top-level directory is an independent Terraform **root** with its own state. Roots read each other's outputs via `terraform_remote_state` using the **local backend** (`../<root>/terraform.tfstate`), so they must be applied in order.

## Prerequisites

- Terraform `~> 1.14` (CI uses 1.14.3)
- A Hetzner Cloud project and API token
- An SSH key pair (default public key path: `~/.ssh/id_ed25519.pub`)
- Optional: [pre-commit](https://pre-commit.com/)

## Usage

Every root requires the `hcloud_token` variable (except `ansible_inventory`). Pass it via the environment so it is never written to disk:

```bash
export TF_VAR_hcloud_token="<your-hetzner-api-token>"
```

Apply the roots in this order:

```bash
for dir in global/ssh_keys core_network bastion; do
  terraform -chdir="$dir" init
  terraform -chdir="$dir" apply
done
```

`bastion` additionally needs `vpn_subnet_cidr` (the WireGuard subnet, no default), e.g. `-var vpn_subnet_cidr=10.8.0.0/24` or a `terraform.tfvars` file. Then apply the services, which depend on `core_network`, `bastion` and `global/ssh_keys`:

```bash
for dir in consul vault k8s; do
  terraform -chdir="$dir" init
  terraform -chdir="$dir" apply
done
```

Finally generate the Ansible inventory:

```bash
terraform -chdir=ansible_inventory init
terraform -chdir=ansible_inventory apply
```

The inventory is written to `../../ansible/inventory/hosts.yaml` (relative to `ansible_inventory/`, i.e. outside this repository) with groups `consul`, `vault`, `bastion`, `k8s_controlplane` and `k8s_worker`.

To tear down, destroy in the reverse order.

### Configurable variables

| Root    | Variable                       | Default        |
|---------|--------------------------------|----------------|
| global/ssh_keys | `ssh_public_key`       | `~/.ssh/id_ed25519.pub` |
| bastion | `vpn_subnet_cidr`              | *required*     |
| bastion | `host_offset_bastion`          | `5`            |
| bastion | `github_ssh_host_key`          | pinned GitHub ed25519 host key |
| consul  | `host_offset_consul`           | `10`           |
| vault   | `host_offset_vault`            | `20`           |
| k8s     | `host_offset_k8s_controlplane` / `host_offset_k8s_worker` | `30` / `41` |
| k8s     | `os_image`, `hetzner_server_type`, `hetzner_server_location`, `common_k8s_node_label` | `ubuntu-22.04`, `cx23`, `nbg1`, `k8s` |

Defaults for the network (`10.50.0.0/16`, subnet `10.50.1.0/24`, zone `eu-central`) live in [modules/core_network/variables.tf](modules/core_network/variables.tf).

## Security notes

- State files contain secrets (including the generated Ansible private key) and are git-ignored (`*.tfstate*`, `*.tfvars`). Never commit them.
- The local backend is for testing only; commented-out Terraform Cloud `remote` backend examples are in the `data.tf` files.
- The generated Ansible private key is injected into the bastion through cloud-init user data.

## Development

[`.pre-commit-config.yaml`](.pre-commit-config.yaml) runs `terraform fmt`, `terraform validate`, `tflint`, Checkov, Gitleaks and a guard that blocks committing `.tfstate` files:

```bash
pre-commit install
pre-commit run --all-files
```

The [Terraform checks](.github/workflows/terraform-checks.yaml) workflow runs on pull requests and pushes to `main`.
