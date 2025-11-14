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
  insecure  = var.vms[local.first].proxmox_tls_insecure
  ssh {
    agent    = true
    username = var.vms[local.first].virtual_environment_username
    # Add private key path for better security
    # private_key = file(pathexpand("~/.ssh/id_rsa"))
  }
}

module "vm" {
  source = "git::https://github.com/nagarajurahul/terraform-proxmox-vm-module.git?ref=v3.0.5"

  for_each = var.vms

  control_server = each.value.control_server

  node_name        = each.value.node_name
  datastore_id     = each.value.datastore_id
  iso_path         = each.value.iso_path
  operating_system = each.value.operating_system

  vm_name       = each.value.vm_name
  vm_hostname   = each.value.vm_hostname
  description   = each.value.description
  tags          = each.value.tags
  vm_on_boot    = each.value.vm_on_boot
  vm_protection = each.value.vm_protection
  environment   = each.value.environment

  cpu       = each.value.cpu
  memory    = each.value.memory
  disk_size = each.value.disk_size

  # Add Network Config

  dns_domain          = each.value.dns_domain
  dns_servers         = each.value.dns_servers
  ca_root_certificate = trimspace(file("root_ca.crt"))

  users         = each.value.users
  lock_password = each.value.lock_password
  # Add git user and email here
  tpm_version = each.value.tpm_version
}
