##########################################
# Terraform → Ansible Bridge Outputs
##########################################

# Per-VM IP map
output "vm_ips" {
  description = "Primary IPv4 address of each VM (non-loopback)."
  value = {
    for name, mod in module.vm :
    name => (
      try(
        [for ip_list in flatten(mod.ipv4_addresses) : ip_list if ip_list != "127.0.0.1"][0],
        null
      )
    )
  }
}

# Hostnames map
output "vm_hostnames" {
  description = "Hostnames of all deployed VMs."
  value = {
    for name, mod in module.vm : name => mod.vm_hostname
  }
}

# Combined inventory map (for automation use)
output "vm_inventory" {
  description = "Combined mapping of hostnames to IP and SSH user."
  value = {
    for name, mod in module.vm :
    name => {
      hostname = mod.vm_hostname
      ansible_host = try(
        [for ip_list in flatten(mod.ipv4_addresses) : ip_list if ip_list != "127.0.0.1"][0],
        null
      )
      ansible_user = "ubuntu"
    }
  }
}
