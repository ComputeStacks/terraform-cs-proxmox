resource "proxmox_vm_qemu" "controller" {
  name = "controller"
  desc = "ComputeStacks controller"
  tags = var.proxmox_controller_tags
  target_node = var.proxmox_controller_host
  onboot = var.proxmox_onboot
  qemu_os = "l26"
  oncreate = true
  agent = 1

  clone = var.proxmox_image
  full_clone = var.proxmox_full_clone

  cpu = var.proxmox_cpu_type
  cores = var.resources_controller_cpu_cores
  sockets = var.resources_controller_cpu_sockets
  memory = var.resources_controller_memory
  balloon = var.resources_controller_memory
  scsihw = "virtio-scsi-pci"
  hotplug = "disk,network,usb"

  disk {
    type = "scsi"
    storage = var.proxmox_controller_storage_loc
    size = var.resources_controller_disk
    discard = var.proxmox_disk_discard
  }

  network {
    model = "virtio"
    bridge = var.proxmox_net_bridge
    tag = var.proxmox_net_vlan
  }

  os_type = "cloud-init"
  ciuser = var.vm_user
  cipassword = random_string.server_password.result
  ipconfig0 = var.proxmox_controller_network

  ssh_user = var.vm_user
  sshkeys = var.ssh_pub_allowed

}

resource "proxmox_vm_qemu" "node_cluster" {
  count = var.proxmox_node_qty
  name = format("node%s%s", var.node_base_name, count.index + 1)
  desc = format("ComputeStacks Node%s%s", var.node_base_name, count.index + 1)
  tags = var.proxmox_node_tags
  target_node = var.proxmox_node_host[count.index]
  onboot = var.proxmox_onboot
  qemu_os = "l26"
  oncreate = true
  agent = 1

  clone = var.proxmox_image
  full_clone = var.proxmox_full_clone

  cpu = var.proxmox_cpu_type
  cores = var.resources_node_cpu_cores
  sockets = var.resources_node_cpu_sockets
  memory = var.resources_node_memory
  balloon = var.resources_node_memory
  scsihw = "virtio-scsi-pci"
  hotplug = "disk,network,usb"

  disk {
    type = "scsi"
    storage = var.proxmox_node_storage_loc[count.index]
    size = var.resources_node_disk
    discard = var.proxmox_disk_discard
  }

  network {
    model = "virtio"
    bridge = var.proxmox_net_bridge
    tag = var.proxmox_net_vlan
  }

  os_type = "cloud-init"
  ciuser = var.vm_user
  cipassword = random_string.server_password.result
  ipconfig0 = var.proxmox_node_network[count.index]

  ssh_user = var.vm_user
  sshkeys = var.ssh_pub_allowed

  lifecycle {
    precondition {
      condition = length(var.proxmox_node_host) == var.proxmox_node_qty
      error_message = "The number of proxmox_node_host must be equal to the number of proxmox_node_qty."
    }
    precondition {
      condition = length(var.proxmox_node_network) == var.proxmox_node_qty
      error_message = "The number of proxmox_node_network must be equal to the number of proxmox_node_qty."
    }
    precondition {
      condition = length(var.proxmox_node_storage_loc) == var.proxmox_node_qty
      error_message = "The number of proxmox_node_storage_loc must be equal to the number of proxmox_node_qty."
    }
  }

}

resource "proxmox_vm_qemu" "metrics" {
  name = "metrics"
  desc = "ComputeStacks Metrics"
  tags = var.proxmox_metrics_tags
  target_node = var.proxmox_metrics_host
  onboot = var.proxmox_onboot
  qemu_os = "l26"
  oncreate = true
  agent = 1

  clone = var.proxmox_image
  full_clone = var.proxmox_full_clone

  cpu = var.proxmox_cpu_type
  cores = var.resources_metrics_cpu_cores
  sockets = var.resources_metrics_cpu_sockets
  memory = var.resources_metrics_memory
  balloon = var.resources_metrics_memory
  scsihw = "virtio-scsi-pci"
  hotplug = "disk,network,usb"

  disk {
    type = "scsi"
    storage = var.proxmox_metrics_storage_loc
    size = var.resources_metrics_disk
    discard = var.proxmox_disk_discard
  }

  network {
    model = "virtio"
    bridge = var.proxmox_net_bridge
    tag = var.proxmox_net_vlan
  }

  os_type = "cloud-init"
  ciuser = var.vm_user
  cipassword = random_string.server_password.result
  ipconfig0 = var.proxmox_metrics_network

  ssh_user = var.vm_user
  sshkeys = var.ssh_pub_allowed

}

resource "proxmox_vm_qemu" "backup" {
  name = "backup"
  desc = "ComputeStacks Backup"
  tags = var.proxmox_backup_tags
  target_node = var.proxmox_backup_host
  onboot = var.proxmox_onboot
  qemu_os = "l26"
  oncreate = true
  agent = 1

  clone = var.proxmox_image
  full_clone = var.proxmox_full_clone

  cpu = var.proxmox_cpu_type
  cores = var.resources_backup_cpu_cores
  sockets = var.resources_backup_cpu_sockets
  memory = var.resources_backup_memory
  balloon = var.resources_backup_memory
  scsihw = "virtio-scsi-pci"
  hotplug = "disk,network,usb"

  disk {
    type = "scsi"
    storage = var.proxmox_backup_storage_loc
    size = var.resources_backup_disk
    discard = var.proxmox_disk_discard
  }

  network {
    model = "virtio"
    bridge = var.proxmox_net_bridge
    tag = var.proxmox_net_vlan
  }

  os_type = "cloud-init"
  ciuser = var.vm_user
  cipassword = random_string.server_password.result
  ipconfig0 = var.proxmox_backup_network

  ssh_user = var.vm_user
  sshkeys = var.ssh_pub_allowed

}

resource "proxmox_vm_qemu" "ns_primary" {
  name = "ns-primary"
  desc = "ComputeStacks Primary NameServer"
  tags = var.proxmox_ns_primary_tags
  target_node = var.proxmox_ns_primary_host
  onboot = var.proxmox_onboot
  qemu_os = "l26"
  oncreate = true
  agent = 1

  clone = var.proxmox_image
  full_clone = var.proxmox_full_clone

  cpu = var.proxmox_cpu_type
  cores = var.resources_ns_primary_cpu_cores
  sockets = var.resources_ns_primary_cpu_sockets
  memory = var.resources_ns_primary_memory
  balloon = var.resources_ns_primary_memory
  scsihw = "virtio-scsi-pci"
  hotplug = "disk,network,usb"

  disk {
    type = "scsi"
    storage = var.proxmox_ns_primary_storage_loc
    size = var.resources_ns_primary_disk
    discard = var.proxmox_disk_discard
  }

  network {
    model = "virtio"
    bridge = var.proxmox_net_bridge
    tag = var.proxmox_net_vlan
  }

  os_type = "cloud-init"
  ciuser = var.vm_user
  cipassword = random_string.server_password.result
  ipconfig0 = var.proxmox_ns_primary_network

  ssh_user = var.vm_user
  sshkeys = var.ssh_pub_allowed

}

resource "proxmox_vm_qemu" "ns_secondary" {
  name = "ns-secondary"
  desc = "ComputeStacks Secondary NameServer"
  tags = var.proxmox_ns_secondary_tags
  target_node = var.proxmox_ns_secondary_host
  onboot = var.proxmox_onboot
  qemu_os = "l26"
  oncreate = true
  agent = 1

  clone = var.proxmox_image
  full_clone = var.proxmox_full_clone

  cpu = var.proxmox_cpu_type
  cores = var.resources_ns_secondary_cpu_cores
  sockets = var.resources_ns_secondary_cpu_sockets
  memory = var.resources_ns_secondary_memory
  balloon = var.resources_ns_secondary_memory
  scsihw = "virtio-scsi-pci"
  hotplug = "disk,network,usb"

  disk {
    type = "scsi"
    storage = var.proxmox_ns_secondary_storage_loc
    size = var.resources_ns_secondary_disk
    discard = var.proxmox_disk_discard
  }

  network {
    model = "virtio"
    bridge = var.proxmox_net_bridge
    tag = var.proxmox_net_vlan
  }

  os_type = "cloud-init"
  ciuser = var.vm_user
  cipassword = random_string.server_password.result
  ipconfig0 = var.proxmox_ns_secondary_network

  ssh_user = var.vm_user
  sshkeys = var.ssh_pub_allowed

}
