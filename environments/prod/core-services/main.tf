module "vm" {
  # v3.3.0
  source   = "git::https://github.com/nagarajurahul/terraform-proxmox-vm-module.git?ref=e9fc9a4a9c62d778e2127e784b97fe3ab98d8210"
  for_each = local.all_vms

  control_server = var.control_server

  # VM identity
  vm_name     = each.value.vm_name
  vm_hostname = each.value.vm_hostname
  description = each.value.description
  tags        = concat(each.value.tags, [each.value.group, var.environment])

  # Resources
  cpu       = each.value.cpu
  memory    = each.value.memory
  disk_size = each.value.disk_size

  # Lifecycle
  vm_on_boot    = each.value.vm_on_boot
  vm_protection = each.value.vm_protection

  # Infrastructure (with per-VM overrides)
  node_name        = each.value.node_name
  datastore_id     = each.value.datastore_id
  iso_path         = each.value.iso_path
  operating_system = each.value.operating_system
  environment      = each.value.environment

  # Network
  dns_domain  = var.network.dns_domain
  dns_servers = var.network.dns_servers

  # Security
  ca_root_certificate = local.ca_certificate
  users               = var.security.users
  lock_password       = var.security.lock_password
  tpm_version         = var.security.tpm_version

  # SSH hardening
  ssh_client_alive_interval  = var.security.ssh.ssh_client_alive_interval
  ssh_client_alive_count_max = var.security.ssh.ssh_client_alive_count_max
  ssh_max_auth_tries         = var.security.ssh.ssh_max_auth_tries
  ssh_max_sessions           = var.security.ssh.ssh_max_sessions

  # Fail2ban
  fail2ban_max_retry = var.security.fail2ban.fail2ban_max_retry
  fail2ban_ban_time  = var.security.fail2ban.fail2ban_ban_time
  fail2ban_find_time = var.security.fail2ban.fail2ban_find_time

  install_docker = var.install_docker
}
