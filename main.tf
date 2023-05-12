provider "hcloud" {
}

resource "hcloud_ssh_key" "ansible_key" {
  name       = "AnsibleKey"
  public_key = file(var.ansible_ssh_key)
}

resource "hcloud_volume" "vol_a" {
  location = "nbg1"
  name     = "vol-a"
  size     = 10 # Volume size in GB
}

resource "hcloud_volume" "vol_b" {
  location = "nbg1"
  name     = "vol-b"
  size     = 10 # Volume size in GB
}

resource "hcloud_volume" "vol_c" {
  location = "nbg1"
  name     = "vol-c"
  size     = 10 # Volume size in GB
}

resource "hcloud_server" "srv_a" {
  name        = "srv-a"
  server_type = "cx11"      # Hetzner Cloud server type
  image       = "debian-11" # OS image for the server
  datacenter  = "nbg1-dc3"
  ssh_keys    = [hcloud_ssh_key.ansible_key.id]
}

resource "hcloud_server" "srv_b" {
  name        = "srv-b"
  server_type = "cx11"      # Hetzner Cloud server type
  image       = "debian-11" # OS image for the server
  datacenter  = "nbg1-dc3"
  ssh_keys    = [hcloud_ssh_key.ansible_key.id]
}

resource "hcloud_server" "srv_c" {
  name        = "srv-c"
  server_type = "cx11"      # Hetzner Cloud server type
  image       = "debian-11" # OS image for the server
  datacenter  = "nbg1-dc3"
  ssh_keys    = [hcloud_ssh_key.ansible_key.id]
}

resource "hcloud_volume_attachment" "srv-vol-a" {
  volume_id = hcloud_volume.vol_a.id
  server_id = hcloud_server.srv_a.id
  automount = true
}
resource "hcloud_volume_attachment" "srv-vol-b" {
  volume_id = hcloud_volume.vol_b.id
  server_id = hcloud_server.srv_b.id
  automount = true
}
resource "hcloud_volume_attachment" "srv-vol-c" {
  volume_id = hcloud_volume.vol_c.id
  server_id = hcloud_server.srv_c.id
  automount = true
}
