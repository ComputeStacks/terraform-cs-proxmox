##
# Proxmox Connection Info
variable "proxmox_api_url" {
  type = string
  default = "127.0.0.1:8086"
}
variable "proxmox_api_token_id" {
  type = string
}
variable "proxmox_api_token_secret" {
  type = string
}
variable "proxmox_insecure_ssl" {
  type = bool
  default = false
}

# Proxmox Terraform Debug Settings
variable "terraform_proxmox_debug" {
  type = bool
  default = false
}
variable "terraform_proxmox_log_to_file" {
  type = bool
  default = false
}
variable "terraform_proxmox_log_file" {
  type = string
  default = "terraform-plugin-proxmox.log"
}

#
# Proxmox Virtual Machine Settings
variable "proxmox_cpu_type" {
  type = string
  default = "host"
  description = "See https://pve.proxmox.com/pve-docs/chapter-qm.html#qm_cpu for more information."
}
variable "proxmox_numa" {
  type = bool
  default = false
  description = "Whether to enable Non-Uniform Memory Access in the guest."
}
variable "proxmox_onboot" {
  type = bool
  default = false
  description = "Should we start this VM when the host boots up?"
}
variable "proxmox_image" {
  type = string
}
variable "proxmox_full_clone" {
  type = bool
  default = true
  description = "For testing, set to false for smaller disk sizes and faster build times. For production, our recommendation is to set to true."
}
variable "proxmox_storage_name" {
  type = string
  default = "local-lvm"
}
variable "proxmox_disk_discard" {
  type = string
  default = "ignore"
  description = "To enable discard, change to: on"
}
variable "proxmox_disk_ssd" {
  type = number
  default = 0
  description = "Whether to expose this drive as an SSD, rather than a rotational hard disk. Change to 1 to enable."
  validation {
    condition = var.proxmox_disk_ssd == 0 || var.proxmox_disk_ssd == 1
    error_message = "Must be either 0 or 1"
  }
}
variable "proxmox_net_bridge" {
  type = string
  default = "vmbr0"
}
variable "proxmox_net_vlan" {
  type = number
  default = -1
  description = "VLAN tag ID. Set to -1 to disable"
}

##
# Virtual Machine Settings
variable "vm_user" {
  type = string
  default = "cstacks"
}
# ssh-keygen -q -C "${USER}@cstacks-terraform" -t ed25519 -N '' -f ~/.ssh/cstacks-terraform <<<y >/dev/null 2>&1 && cat ~/.ssh/cstacks-terraform.pub
variable "ssh_connection_priv_key_path" {
  type = string
  default = "~/.ssh/id_rsa"
  description = "Path to your private key"
}
variable "ssh_pub_allowed" {
  type = string
}
# Used to create a consistent naming scheme for our nodes.
# This is for our recommend hostname scheme for nodes:
# * 3 digits for each node, following an identifier like 'node'.
# * 1st digit is the region (e.g. 1, 2, 3)
# * 2nd digit is the availability-zone
# * 3rd digit is the node.
variable "node_base_name" {
	type = string
	default = "10" # '10' would create node101, node102, node103, etc.
}

##
# Controller Settings
variable "proxmox_controller_host" {
  type = string
  default = "localhost"
}
variable "proxmox_controller_tags" {
  type = string
  description = "comma-separated list of tags"
  default = null
  nullable = true
}
variable "resources_controller_cpu_cores" {
  type = number
  default = 4
}
variable "resources_controller_cpu_sockets" {
  type = number
  default = 1
}
variable "resources_controller_memory" {
  type = number
  default = 4096
}
variable "resources_controller_disk" {
  type = string
  default = "50G"
}
variable "proxmox_controller_network" {
  type = string
  default = "ip=dhcp,ip6=auto"
}
variable "proxmox_controller_storage_loc" {
  type = string
  default = "local-lvm"
  description = "Name of storage location in proxmox, such as local-zfs, local-lvm, mynas, etc."
}

##
# Node Settings
variable "proxmox_node_qty" {
  type = number
  default = 1
  description = "Number of nodes to create"
  validation {
    condition = var.proxmox_node_qty > 0
    error_message = "Must be at least 1"
  }
}
variable "proxmox_node_host" {
  type = list
  default = ["localhost"]
  description = "Must be equal to the number of nodes you chose. For example, 3 nodes would require 3 values!"
  validation {
    condition = length(var.proxmox_node_host) > 0
    error_message = "You must supply at least 1 proxmox_node_host."
  }
}
variable "proxmox_node_storage_loc" {
  type = list
  default = ["local-lvm"]
  description = "Name of storage location in proxmox, such as local-zfs, local-lvm, mynas, etc."
  validation {
    condition = length(var.proxmox_node_storage_loc) > 0
    error_message = "You must supply at least 1 proxmox_node_storage_loc."
  }
}
variable "proxmox_node_network" {
  type = list
  default = ["ip=dhcp,ip6=auto"]
  description = "Must be equal to the number of nodes you chose. For example, 3 nodes would require 3 values!"
  validation {
    condition = length(var.proxmox_node_network) > 0
    error_message = "You must supply at least 1 proxmox_node_network."
  }
}
variable "proxmox_node_tags" {
  type = string
  description = "comma-separated list of tags"
  default = null
  nullable = true
}
variable "resources_node_cpu_cores" {
  type = number
  default = 4
}
variable "resources_node_cpu_sockets" {
  type = number
  default = 1
}
variable "resources_node_memory" {
  type = number
  default = 4096
}
variable "resources_node_disk" {
  type = string
  default = "100G"
}

##
# Metrics Settings
variable "proxmox_metrics_host" {
  type = string
  default = "localhost"
}
variable "proxmox_metrics_tags" {
  type = string
  description = "comma-separated list of tags"
  default = null
  nullable = true
}
variable "resources_metrics_cpu_cores" {
  type = number
  default = 2
}
variable "resources_metrics_cpu_sockets" {
  type = number
  default = 1
}
variable "resources_metrics_memory" {
  type = number
  default = 4096
}
variable "resources_metrics_disk" {
  type = string
  default = "100G"
}
variable "proxmox_metrics_network" {
  type = string
  default = "ip=dhcp,ip6=auto"
}
variable "proxmox_metrics_storage_loc" {
  type = string
  default = "local-lvm"
  description = "Name of storage location in proxmox, such as local-zfs, local-lvm, mynas, etc."
}

##
# Backup Settings
variable "proxmox_backup_host" {
  type = string
  default = "localhost"
}
variable "proxmox_backup_tags" {
  type = string
  description = "comma-separated list of tags"
  default = null
  nullable = true
}
variable "resources_backup_cpu_cores" {
  type = number
  default = 1
}
variable "resources_backup_cpu_sockets" {
  type = number
  default = 1
}
variable "resources_backup_memory" {
  type = number
  default = 1024
}
variable "resources_backup_disk" {
  type = string
  default = "10G"
}
variable "proxmox_backup_network" {
  type = string
  default = "ip=dhcp,ip6=auto"
}
variable "proxmox_backup_storage_loc" {
  type = string
  default = "local-lvm"
  description = "Name of storage location in proxmox, such as local-zfs, local-lvm, mynas, etc."
}

##
# Nameserver Primary Settings
variable "proxmox_ns_primary_host" {
  type = string
  default = "localhost"
}
variable "override_pdns_endpoint" {
  type = bool
  default = false
  description = "Force the controller to use the IP of the primary nameserver, rather than the domain name, when connecting."
}
variable "proxmox_ns_primary_tags" {
  type = string
  description = "comma-separated list of tags"
  default = null
  nullable = true
}
variable "resources_ns_primary_cpu_cores" {
  type = number
  default = 1
}
variable "resources_ns_primary_cpu_sockets" {
  type = number
  default = 1
}
variable "resources_ns_primary_memory" {
  type = number
  default = 1024
}
variable "resources_ns_primary_disk" {
  type = string
  default = "10G"
}
variable "proxmox_ns_primary_network" {
  type = string
  default = "ip=dhcp,ip6=auto"
}
variable "proxmox_ns_primary_storage_loc" {
  type = string
  default = "local-lvm"
  description = "Name of storage location in proxmox, such as local-zfs, local-lvm, mynas, etc."
}

##
# Nameserver Secondary Settings
variable "proxmox_ns_secondary_host" {
  type = string
  default = "localhost"
}
variable "proxmox_ns_secondary_tags" {
  type = string
  description = "comma-separated list of tags"
  default = null
  nullable = true
}
variable "resources_ns_secondary_cpu_cores" {
  type = number
  default = 1
}
variable "resources_ns_secondary_cpu_sockets" {
  type = number
  default = 1
}
variable "resources_ns_secondary_memory" {
  type = number
  default = 1024
}
variable "resources_ns_secondary_disk" {
  type = string
  default = "10G"
}
variable "proxmox_ns_secondary_network" {
  type = string
  default = "ip=dhcp,ip6=auto"
}
variable "proxmox_ns_secondary_storage_loc" {
  type = string
  default = "local-lvm"
  description = "Name of storage location in proxmox, such as local-zfs, local-lvm, mynas, etc."
}

##
# ComputeStacks
variable "region_name" {
  type = string
  default = "default"
}
variable "cs_currency" {
  type = string
  default = "USD"
}
variable "zone_name" {
  type = string
  description = "The base zone name, example: mydomain.com"
}
variable "cs_app_url" {
  type = string
  default = "a.default"
}
variable "cs_network_range" {
  type = string
  default = "10.100.0.0/21"
}
variable "cs_portal_domain" {
  type = string
  default = "portal.default"
}
variable "cs_registry_domain" {
  type = string
  default = "cr.default"
}
variable "cs_metrics_domain" {
  type = string
  default = "metrics.default"
}
variable "docker_registry_mirror" {
  type = string
  default = ""
  description = "Optionally supply a docker registry mirror for use by ComputeStacks."
}

# Admin User
variable "cs_admin_email" {
  type = string
  default = "root@localhost"
}

##
# PowerDNS
variable "primary_nameserver_zone" {
  type = string
  default = ""
}
variable "secondary_nameserver_zone" {
  type = string
  default = ""
}
variable "primary_nameserver_domain" {
  type = string
  default = ""
}

variable "secondary_nameserver_domain" {
  type = string
  default = ""
}


##
# CloudFlare Auto Provisioning
#acme_cf_token: "" # API Token
#acme_cf_account: "" # Account ID
variable "cloudflare_api_token" {
  type = string
  default = ""
}
variable "cloudflare_account_id" {
  type = string
  default = ""
}
variable "cloudflare_proxied" {
  type = bool
  default = false
  description = "Enable if you want cloudflare to proxy your traffic."
}
