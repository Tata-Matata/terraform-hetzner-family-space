output "control_plane_private_ips" {
  value = [for cp in module.k8s_controlplane_server : cp.server_private_ip]
}

output "controlplane_server_labels" {
  value = [for cp in module.k8s_controlplane_server : cp.server_labels]
}

output "worker_private_ips" {
  value = [for w in module.k8s_worker_server : w.server_private_ip]
}

output "worker_server_labels" {
  value = [for w in module.k8s_worker_server : w.server_labels]
}

