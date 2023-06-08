variable "ansible_ssh_key" {
  type = string
}
variable "ansible_ssh_priv_path" {
  type = string
}

variable "local_offset" {
  type    = string
  default = ""
}

variable "ceph_public_network" {
  type    = string
  description = "value of the ceph public network, must bee in CIDR format and in range of 10.0.0.0/16"
  default = "10.0.0.0/24"
    validation {
    condition     = can(cidrnetmask(var.ceph_public_network))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
  }

variable "ntp_timezone" {
  description = "value of the timezone to set"
  type        = string
  default     = "UTC"

}
variable "ntp_restrict" {
  description = "list of hosts where to allow ntp connections"
  type        = list(string)
  default     = []
}
variable "ntp_manage_config" {
  description = "if set to true, ansible will manage the ntp config file"
  type        = bool
  default     = true
}

variable "cephadm_ceph_releases" {
  description = "value of the ceph release to install"
  type        = string
  default     = "quincy"
  #default     = "pacific"
}

variable "cephadm_enable_dashboard" {
  type    = bool
  default = true
}
variable "cephadm_enable_monitoring" {
  type    = bool
  default = true
}

variable "ceph_ssh_user" {
  type    = string
  default = "root"
}

variable "ansible_user" {
  type    = string
  default = "root"
}

variable "cephadm_public_interface" {
  description = "value of the public interface, workaround till it can be determined automatically"
  type        = string
  default     = "eth0"
#  default     = "ens10"
}
variable "cephadm_admin_interface" {
  description = "value of the public interface, workaround till it can be determined automatically"
  type        = string
  default     = "eth0"
 # default     = "ens10"
}

variable "cephadm_osd_spec" {
  description = "String to specifify matching disks for osd"
  type        = string
  default     = <<EOS
service_type: osd
service_id: osd_spec_default
placement:
  host_pattern: '*'
data_devices:
  all: true

EOS
}
