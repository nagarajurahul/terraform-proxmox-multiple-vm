module "vm" {
  source = "git::https://github.com/nagarajurahul/terraform-proxmox-vm-module.git?ref=v3.2.0"
  for_each = local.all_vms

  # VM properties
  vm_name       = each.value.vm_name
  vm_hostname   = each.value.vm_hostname
  description   = each.value.description
  tags          = each.value.tags
  cpu           = each.value.cpu
  memory        = each.value.memory
  disk_size     = each.value.disk_size
  vm_on_boot    = each.value.vm_on_boot
  vm_protection = each.value.vm_protection

  # Cluster + storage + other overrides
  node_name    = each.value.node_name
  datastore_id = each.value.datastore_id
  iso_path         = var.value.iso_path
  operating_system = var.value.operating_system
  environment      = var.value.environment

  # Defaults
  dns_domain          = var.vm_defaults.dns_domain
  dns_servers         = var.vm_defaults.dns_servers

  ca_root_certificate = trimspace(try(file("${path.module}/root_ca.crt"), ""))
  
  users         = var.vm_defaults.users
  lock_password = var.vm_defaults.lock_password
  tpm_version   = var.vm_defaults.tpm_version

  ssh_client_alive_interval  = var.vm_defaults.ssh_client_alive_interval
  ssh_client_alive_count_max = var.vm_defaults.ssh_client_alive_count_max
  ssh_max_auth_tries         = var.vm_defaults.ssh_max_auth_tries
  ssh_max_sessions           = var.vm_defaults.ssh_max_sessions

  fail2ban_max_retry = var.vm_defaults.fail2ban_max_retry
  fail2ban_ban_time  = var.vm_defaults.fail2ban_ban_time
  fail2ban_find_time = var.vm_defaults.fail2ban_find_time
}
