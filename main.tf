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

module "vm" {
  source = "git::https://github.com/nagarajurahul/terraform-proxmox-vm-module.git?ref=v1.0.2"

  for_each = var.vms

  virtual_environment_endpoint  = each.value.virtual_environment_endpoint
  virtual_environment_api_token = each.value.virtual_environment_api_token
  virtual_environment_username  = each.value.virtual_environment_username

  node_name    = each.value.node_name
  datastore_id = each.value.datastore_id
  vm_name      = each.value.vm_name
  vm_hostname  = each.value.vm_hostname
  description  = each.value.description
  tags         = each.value.tags
  vm_on_boot   = each.value.vm_on_boot

  iso_path         = each.value.iso_path
  operating_system = each.value.operating_system
  cpu              = each.value.cpu
  memory           = each.value.memory
  default_user     = each.value.default_user
  users            = each.value.users
  tpm_version      = each.value.tpm_version
}
