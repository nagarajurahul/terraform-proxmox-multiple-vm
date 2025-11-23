# =============================================================================
# Outputs - For Ansible integration and cross-tier references
# =============================================================================

# -----------------------------------------------------------------------------
# Raw Data Outputs (for programmatic consumption)
# -----------------------------------------------------------------------------
output "vm_ips" {
  description = "Map of VM names to their primary IPv4 addresses"
  value = {
    for key, vm in module.vm : key => vm.vm_ipv4_addresses
  }
}

output "vm_hostnames" {
  description = "Map of VM names to their hostnames"
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
          module.vm[key].vm_ipv4_addresses,
          var.ansible_user
        )
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
            ansible_host = vm.vm_ipv4_addresses
            ansible_user = var.ansible_user
            vm_group     = local.all_vms[key].group
            environment  = var.environment
          }
        }
      }
      all = {
        children = local.groups
      }
    },
    # Dynamic group definitions merged in
    {
      for group in local.groups : group => {
        hosts = [for k, v in local.vms_by_group[group] : module.vm[k].vm_hostname]
      }
    }
  ))
}
