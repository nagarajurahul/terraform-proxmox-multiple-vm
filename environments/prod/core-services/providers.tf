provider "proxmox" {
  endpoint  = var.proxmox.virtual_environment_endpoint
  api_token = var.proxmox.virtual_environment_api_token
  insecure  = var.proxmox.proxmox_tls_insecure

  ssh {
    agent    = true
    username = var.proxmox.virtual_environment_username
  }
}
