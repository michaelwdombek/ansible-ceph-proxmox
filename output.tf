output "ansible_inventory" {
  value = {
    all = {
      vars = {
        ntp_timezone              = var.ntp_timezone
        cephadm_ceph_releases     = var.cephadm_ceph_releases
        cephadm_package_update    = true
        cephadm_enable_dashboard  = var.cephadm_enable_dashboard
        cephadm_enable_monitoring = var.cephadm_enable_monitoring
        cephadm_ssh_user          = var.ceph_ssh_user
        cephadm_public_network    = format("\"%s/32\"", join("/32, ", [for srv in hcloud_server.servers : srv.ipv4_address]))
        #cephadm_public_network    = hcloud_network_subnet.ceph_public_subnet.ip_range
        cephadm_public_interface  = var.cephadm_public_interface
        cephadm_cluster_network = hcloud_network_subnet.ceph_public_subnet.ip_range
        cephadm_cluster_interface   = var.cephadm_admin_interface
        cephadm_admin_interface   = var.cephadm_admin_interface
      }
      hosts = {
        for srv in hcloud_server.servers : srv.name => {
          ansible_host                 = srv.ipv4_address
          ansible_user                 = var.ansible_user
          ansible_ssh_private_key_file = var.ansible_ssh_priv_path
        }
      }
      children = {
        ceph = {
          hosts = {
            for srv in hcloud_server.servers : srv.name => {}
          }
        }
        mons = {
          hosts = {
            for srv in hcloud_server.servers : srv.name => {}
          }
        }
        mgrs = {
          hosts = {
            for srv in hcloud_server.servers : srv.name => {}
          }
        }
        osds = {
          vars = {
            cephadm_osd_spec = var.cephadm_osd_spec
          }
          hosts = {
            for srv in hcloud_server.servers : srv.name => {}
          }
        }
      }
    }
  }
}
