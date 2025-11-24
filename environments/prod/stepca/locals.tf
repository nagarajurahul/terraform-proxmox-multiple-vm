# =============================================================================
# Locals - Data transformations
# =============================================================================

locals {
  # Flatten VM groups into a single map with computed values
  all_vms = merge([
    for group, vms in var.vms : {
      for vm_key, vm in vms :
      "${group}-${vm_key}" => {
        # Identity
        vm_name     = vm.vm_name
        vm_hostname = vm.vm_hostname
        description = vm.description
        tags        = vm.tags
        group       = group

        # Resources
        cpu       = vm.cpu
        memory    = vm.memory
        disk_size = vm.disk_size

        # Lifecycle
        vm_on_boot    = vm.vm_on_boot
        vm_protection = vm.vm_protection

        # Infrastructure (with fallback to defaults)
        node_name        = coalesce(vm.node_name, var.infrastructure.node_name)
        datastore_id     = coalesce(vm.datastore_id, var.infrastructure.datastore_id)
        iso_path         = coalesce(vm.iso_path, var.infrastructure.iso_path)
        operating_system = coalesce(vm.operating_system, var.infrastructure.operating_system)
        environment      = var.environment
      }
    }
  ]...)

  # Group membership for inventory generation
  groups = distinct([for k, v in local.all_vms : v.group])

  vms_by_group = {
    for group in local.groups : group => {
      for k, v in local.all_vms : k => v if v.group == group
    }
  }

  # CA certificate handling
  ca_certificate = var.ca_cert_path != "" ? trimspace(file(var.ca_cert_path)) : ""
}
