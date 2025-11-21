provider "proxmox" {
  endpoint  = var.vm_defaults.virtual_environment_endpoint
  api_token = var.vm_defaults.virtual_environment_api_token
  insecure  = var.vm_defaults.proxmox_tls_insecure

  ssh {
    agent    = true
    username = var.vm_defaults.virtual_environment_username
  }
}
