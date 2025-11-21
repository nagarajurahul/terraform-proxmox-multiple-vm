output "ansible_inventory_ini" {
  description = "Ansible inventory (INI formatted)."
  value = join("\n", [
    for key, vm in module.vm : format(
      "%s ansible_host=%s ansible_user=%s",
      vm.vm_hostname,
      vm.ipv4_address,
      var.vm_groups.default_user
    )
  ])
}
