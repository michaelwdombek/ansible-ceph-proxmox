provider "hcloud" {
}

locals {
  global_vars = {
    server_image = "debian-11"
    dc           = "nbg1-dc3"
    server_type  = "cx11"
    location     = "nbg1"
    storage_size = 10
    label        = "ceph"
  }
  servers = {
    "srv_a" = {
      name      = "a-${var.local_offset}"
      ceph_role = "admin"
    },
    "srv_b" = {
      name      = "b-${var.local_offset}"
      ceph_role = "worker"
    },
    "srv_c" = {
      name      = "c-${var.local_offset}"
      ceph_role = "worker"
    }
  }
}


resource hcloud_network "ceph_network" {
  name = "${var.local_offset}ceph"
  ip_range = "10.0.0.0/16"
}
resource hcloud_network_subnet "ceph_public_subnet" {
  network_id = hcloud_network.ceph_network.id
  type = "cloud"
  network_zone = "eu-central"
  ip_range = var.ceph_public_network
}

resource "hcloud_ssh_key" "ansible_key" {
  name       = "${var.local_offset}AnsibleKey"
  public_key = var.ansible_ssh_key
}

resource "hcloud_server" "servers" {
  for_each = local.servers

  name        = join("", [each.value.name, "srv"])
  server_type = local.global_vars.server_type
  image       = local.global_vars.server_image
  datacenter  = local.global_vars.dc
  labels = {
    "role"        = each.value.ceph_role != null ? each.value.ceph_role : "worker"
    "global_role" = local.global_vars.label
  }
  ssh_keys = [hcloud_ssh_key.ansible_key.id]
}
resource hcloud_server_network "server_network_if" {
  for_each = hcloud_server.servers
  server_id = hcloud_server.servers[each.key].id
  network_id = hcloud_network.ceph_network.id
}

resource "hcloud_volume" "volumes" {
  for_each = local.servers
  name     = join("", [each.value.name, "vol"])
  size     = local.global_vars.storage_size
  location = local.global_vars.location
}

resource "hcloud_volume_attachment" "srv-vol" {
  for_each  = local.servers
  server_id = hcloud_server.servers[each.key].id
  volume_id = hcloud_volume.volumes[each.key].id
  automount = true
}
