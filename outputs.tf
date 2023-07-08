resource "local_file" "inventory" {
  content = templatefile("outputs/inventory.yml.tmpl", {
    ssh_priv_key = var.ssh_connection_priv_key_path,
    node_public = proxmox_vm_qemu.node.default_ipv4_address,
    node_private = proxmox_vm_qemu.node.default_ipv4_address,
    registry_public = proxmox_vm_qemu.controller.default_ipv4_address,
    registry_private = proxmox_vm_qemu.controller.default_ipv4_address,
    metrics_public = proxmox_vm_qemu.metrics.default_ipv4_address,
    metrics_private = proxmox_vm_qemu.metrics.default_ipv4_address,
    controller_public = proxmox_vm_qemu.controller.default_ipv4_address,
    controller_private = proxmox_vm_qemu.controller.default_ipv4_address,
    backup_public = proxmox_vm_qemu.backup.default_ipv4_address,
    backup_private = proxmox_vm_qemu.backup.default_ipv4_address,
    pg_pass = random_string.pg_password.result,
    loki_pass = random_string.loki_password.result,
    prom_pass = random_string.prometheus_password.result,
    backup_key = random_string.backup_key.result,
    app_id = random_string.app_id.result,
    network_range = var.cs_network_range,
    region_name = var.region_name,
    currency = var.cs_currency,
    zone_name = var.zone_name,
    cs_app_url = format("%s.%s", var.cs_app_url, var.zone_name),
    cs_portal_domain = format("%s.%s", var.cs_portal_domain, var.zone_name),
    cs_registry_domain = format("%s.%s", var.cs_registry_domain, var.zone_name),
    cs_metrics_domain = format("%s.%s", var.cs_metrics_domain, var.zone_name),
    cs_admin_email = var.cs_admin_email,
    cs_admin_password = random_string.cs_admin_password.result,
    nsone_public = proxmox_vm_qemu.ns_primary.default_ipv4_address,
    nstwo_public = proxmox_vm_qemu.ns_secondary.default_ipv4_address,
    primary_nameserver_domain = format("%s.%s", var.primary_nameserver_domain, var.primary_nameserver_zone),
    secondary_nameserver_domain = format("%s.%s", var.secondary_nameserver_domain, var.secondary_nameserver_zone),
    acme_cf_token = var.cloudflare_api_token,
    acme_cf_account = var.cloudflare_account_id,
    docker_registry_mirror = var.docker_registry_mirror,
    override_pdns_endpoint = var.override_pdns_endpoint
  })
  filename = "result/inventory.yml"
}

resource "local_file" "dns_settings" {
  content = templatefile("outputs/dns_settings.txt.tmpl", {
    cs_app_url = format("%s.%s", var.cs_app_url, var.zone_name),
    cs_portal_domain = format("%s.%s", var.cs_portal_domain, var.zone_name),
    cs_registry_domain = format("%s.%s", var.cs_registry_domain, var.zone_name),
    cs_metrics_domain = format("%s.%s", var.cs_metrics_domain, var.zone_name),
    controller_public = proxmox_vm_qemu.controller.default_ipv4_address,
    metrics_public = proxmox_vm_qemu.metrics.default_ipv4_address,
    registry_public = proxmox_vm_qemu.controller.default_ipv4_address,
    nsone_public = proxmox_vm_qemu.ns_primary.default_ipv4_address,
    nstwo_public = proxmox_vm_qemu.ns_secondary.default_ipv4_address,
    primary_nameserver_domain = format("%s.%s", var.primary_nameserver_domain, var.primary_nameserver_zone),
    secondary_nameserver_domain = format("%s.%s", var.secondary_nameserver_domain, var.secondary_nameserver_zone),
    node_public = proxmox_vm_qemu.node.default_ipv4_address
  })
  filename = "result/dns_settings.txt"
}
