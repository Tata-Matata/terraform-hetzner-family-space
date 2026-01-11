output "control_plane_ip" {
  value = hcloud_server.control_plane.ipv4_address
}

output "worker_ips" {
  value = [for w in hcloud_server.worker : w.ipv4_address]
}

output "server_types" {
  value = [for s in data.hcloud_server_types.all.server_types : s.name]
}
