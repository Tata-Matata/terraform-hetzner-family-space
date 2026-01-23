resource "local_file" "ansible_inventory" {
  filename = "../../ansible/inventory/hosts.yaml"

  content = templatefile(
    "${path.module}/templates/inventory.yaml.tftpl",
    {
      consul_private_ips   = data.terraform_remote_state.consul.outputs.consul_private_ips
      vault_private_ips    = data.terraform_remote_state.vault.outputs.vault_private_ips
      k8s_controlplane_ips = data.terraform_remote_state.k8s.outputs.control_plane_private_ips
      k8s_worker_ips       = data.terraform_remote_state.k8s.outputs.worker_private_ips
      bastion_private_ip   = data.terraform_remote_state.bastion.outputs.bastion_private_ip
    }
  )
}
