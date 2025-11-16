variable "vms" {
  description = "Map of VMs to create."
  type = map(object({
    control_server                = bool
    virtual_environment_endpoint  = string
    virtual_environment_api_token = string
    proxmox_tls_insecure          = bool
    virtual_environment_username  = string
    node_name                     = string
    datastore_id                  = string
    iso_path                      = string
    operating_system              = string
    environment                   = string
    vm_name                       = string
    vm_hostname                   = string
    description                   = string
    tags                          = list(string)
    vm_on_boot                    = bool
    vm_protection                 = bool
    cpu                           = number
    memory                        = number
    disk_size                     = number
    dns_domain                    = string
    dns_servers                   = list(string)
    users = map(object({
      hashed_password     = string
      ssh_authorized_keys = list(string)
    }))
    lock_password              = bool
    tpm_version                = string
    ssh_client_alive_interval  = number
    ssh_client_alive_count_max = number
    ssh_max_auth_tries         = number
    ssh_max_sessions           = number
    fail2ban_max_retry         = number
    fail2ban_ban_time          = number
    fail2ban_find_time         = number
  }))
}
