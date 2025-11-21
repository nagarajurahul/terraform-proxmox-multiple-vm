locals {
  # Merge and flatten core-services groups
  all_vms = merge([
    for group, vms in var.vm_groups : {
      for vm_key, vm in vms :
      "${group}-${vm_key}" => merge(
        vm,
        {
          group            = group
          node_name        = coalesce(vm.node_name, var.vm_defaults.node_name)
          datastore_id     = coalesce(vm.datastore_id, var.vm_defaults.datastore_id)
          iso_path         = coalesce(vm.iso_path, var.vm_defaults.iso_path)
          operating_system = coalesce(vm.operating_system, var.vm_defaults.operating_system)
          environment      = coalesce(vm.environment, var.vm_defaults.environment)
        }
      )
    }
  ]...)
}
