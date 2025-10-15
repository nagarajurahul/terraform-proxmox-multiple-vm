terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.1"
    }
  }
}

locals {
  first = keys(var.vms)[0]
}

provider "proxmox" {
  endpoint  = var.vms[local.first].virtual_environment_endpoint
  api_token = var.vms[local.first].virtual_environment_api_token
  insecure  = true
  ssh {
    agent    = true
    username = var.vms[local.first].virtual_environment_username
  }
}
