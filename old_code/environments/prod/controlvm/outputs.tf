# =============================================================================
# Outputs - For Ansible integration and cross-tier references
# =============================================================================

# -----------------------------------------------------------------------------
# Local helper to extract primary IP (excluding loopback/link-local)
# -----------------------------------------------------------------------------
locals {
  # Extract primary (non-loopback, non-link-local) IPv4 address per VM
  vm_primary_ips = {
    for key, vm in module.vm : key => try(
      # Flatten nested list and filter valid IPs
      [
        for ip in flatten(vm.vm_ipv4_addresses) :
        ip if !can(regex("^(127\\.|169\\.254\\.)", ip))
      ][0],
      null
    )
  }
}

# -----------------------------------------------------------------------------
# Raw Data Outputs (for programmatic consumption)
# -----------------------------------------------------------------------------
output "vm_ips" {
  description = "Map of VM keys to their primary IPv4 addresses (excluding loopback)"
  value       = local.vm_primary_ips
}

output "vm_ips_all" {
  description = "Map of VM keys to ALL their IPv4 addresses (for debugging)"
  value = {
    for key, vm in module.vm : key => vm.vm_ipv4_addresses
  }
}

output "vm_hostnames" {
  description = "Map of VM keys to their hostnames"
  value = {
    for key, vm in module.vm : key => vm.vm_hostname
  }
}

# -----------------------------------------------------------------------------
# Ansible Inventory - INI Format (grouped)
# -----------------------------------------------------------------------------
output "ansible_inventory_ini" {
  description = "Ansible inventory in INI format, organized by group"
  value = join("\n\n", [
    for group in local.groups : join("\n", concat(
      ["[${group}]"],
      [
        for key, vm in local.vms_by_group[group] :
        format(
          "%s ansible_host=%s ansible_user=%s",
          module.vm[key].vm_hostname,
          local.vm_primary_ips[key],
          var.ansible_user
        ) if local.vm_primary_ips[key] != null
      ]
    ))
  ])
}

# -----------------------------------------------------------------------------
# Ansible Inventory - JSON Format (for dynamic inventory)
# -----------------------------------------------------------------------------
output "ansible_inventory_json" {
  description = "Ansible inventory in JSON format for dynamic inventory scripts"
  value = jsonencode(merge(
    {
      _meta = {
        hostvars = {
          for key, vm in module.vm : vm.vm_hostname => {
            ansible_host = local.vm_primary_ips[key]
            ansible_user = var.ansible_user
            vm_group     = local.all_vms[key].group
            environment  = var.environment
          } if local.vm_primary_ips[key] != null
        }
      }
      all = {
        children = local.groups
      }
    },
    # Dynamic group definitions merged in
    {
      for group in local.groups : group => {
        hosts = [
          for k, v in local.vms_by_group[group] : module.vm[k].vm_hostname
          if local.vm_primary_ips[k] != null
        ]
      }
    }
  ))
}
