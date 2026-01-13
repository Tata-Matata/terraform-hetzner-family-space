//parent network equivalent to VPC in AWS
resource "hcloud_network" "private_net" {
  name     = "private-net"
  ip_range = var.private_network_cidr
}

//actual usable subnet inside the parent network
//VMs get IPs from this subnet
resource "hcloud_network_subnet" "private_subnet" {
  network_id   = hcloud_network.private_net.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = var.private_subnet_cidr
}


//Later we can separate into
//10.50.1.0/24 → bastion + infra
//10.50.2.0/24 → k8s nodes
//10.50.3.0/24 → future services
//all inside one network and subnet for simplicity now