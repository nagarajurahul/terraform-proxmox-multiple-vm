variable "vms" {
  description = "Map of VMs to create."
  type = map(object({
    control_server                = bool
    virtual_environment_endpoint  = string
    virtual_environment_api_token = string
    virtual_environment_username  = string
    node_name                     = string
    datastore_id                  = string
    vm_name                       = string
    vm_hostname                   = string
    description                   = string
    tags                          = list(string)
    vm_on_boot                    = bool
    iso_path                      = string
    operating_system              = string
    cpu                           = number
    memory                        = number
    disk_size                     = number
    default_user                  = string
    users = map(object({
      password            = string
      ssh_authorized_keys = list(string)
    }))
    tpm_version = string
  }))
}
