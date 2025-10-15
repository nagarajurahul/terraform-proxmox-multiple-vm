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
