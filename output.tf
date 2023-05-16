output "ansible_inventory" {
  value = {
    all = {
      children = {
        ceph = {
          srv-a = {
            ansible_host = hcloud_server.srv_a.ipv4_address
          }
          srv-b = {
            ansible_host = hcloud_server.srv_b.ipv4_address
          }
          srv-c = {
            ansible_host = hcloud_server.srv_a.ipv4_address
          }
        }
      }
    }
  }
}
