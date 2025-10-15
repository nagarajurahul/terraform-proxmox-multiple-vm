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

# Human-readable INI (for direct copy to ansible hosts file)
output "ansible_inventory_ini" {
  description = "Ansible inventory (INI formatted)."
  value = join("\n", concat(
    ["[vms]"],
    [
      for name, mod in module.vm :
      format(
        "%s ansible_host=%s ansible_user=%s",
        mod.vm_hostname,
        try(
          [for ip_list in flatten(mod.ipv4_addresses) : ip_list if ip_list != "127.0.0.1"][0],
          "N/A"
        ),
        "ubuntu"
      )
    ]
  ))
}

# Machine-readable JSON (for dynamic inventory or tooling)
output "ansible_inventory_json" {
  description = "Ansible inventory formatted in JSON for dynamic use."
  value = {
    all = {
      hosts = [
        for name, mod in module.vm : {
          name = mod.vm_hostname
          ansible_host = try(
            [for ip_list in flatten(mod.ipv4_addresses) : ip_list if ip_list != "127.0.0.1"][0],
            null
          )
          ansible_user = "ubuntu"
        }
      ]
    }
  }
}
