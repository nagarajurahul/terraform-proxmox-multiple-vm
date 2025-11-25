# =============================================================================
# Variables - Organized as per concern
# =============================================================================

variable "environment" {
  description = "Environment name (prod, staging, dev)"
  type        = string
  validation {
    condition     = contains(["prod", "staging", "dev"], var.environment)
    error_message = "Environment must be prod, staging, or dev."
  }
}

# -----------------------------------------------------------------------------
# Proxmox Provider Configuration
# -----------------------------------------------------------------------------
variable "proxmox" {
  description = "Proxmox connection settings"
  type = object({
    virtual_environment_endpoint  = string
    virtual_environment_api_token = string
    proxmox_tls_insecure          = bool
    virtual_environment_username  = string
  })
  sensitive = true
}

# -----------------------------------------------------------------------------
# Infrastructure Defaults
# -----------------------------------------------------------------------------
variable "infrastructure" {
  description = "Default infrastructure settings"
  type = object({
    node_name        = string
    datastore_id     = string
    iso_path         = string
    operating_system = string
  })
}

# -----------------------------------------------------------------------------
# Network Configuration
# -----------------------------------------------------------------------------
variable "network" {
  description = "Network settings"
  type = object({
    dns_domain  = string
    dns_servers = list(string)
  })
}

# -----------------------------------------------------------------------------
# Security Configuration
# -----------------------------------------------------------------------------
variable "security" {
  description = "Security settings"
  type = object({
    lock_password = bool
    tpm_version   = string
    users = map(object({
      hashed_password     = string
      ssh_authorized_keys = list(string)
    }))
    ssh = object({
      ssh_client_alive_interval  = number
      ssh_client_alive_count_max = number
      ssh_max_auth_tries         = number
      ssh_max_sessions           = number
    })
    fail2ban = object({
      fail2ban_max_retry = number
      fail2ban_ban_time  = number
      fail2ban_find_time = number
    })
  })
  sensitive = true
}

# Separate variable for Ansible inventory output
variable "ansible_user" {
  description = "Default SSH user for Ansible connections"
  type        = string
}

# Control Server Flag
variable "control_server" {
  type        = bool
  default     = false
  description = "Please define whether this is control server or not. Control server flag will determine the cloud-init template."
}

# Install Docker Flag
variable "install_docker" {
  type        = bool
  default     = true
  description = "Whether to install Docker during cloud-init"
}

# -----------------------------------------------------------------------------
# VM Definitions
# -----------------------------------------------------------------------------
variable "vms" {
  description = "VM definitions for this service tier"
  type = map(map(object({
    vm_name     = string
    vm_hostname = string
    description = string
    tags        = list(string)
    cpu         = number
    memory      = number
    disk_size   = number

    vm_on_boot    = optional(bool, true)
    vm_protection = optional(bool, true)

    # Per-VM overrides
    node_name        = optional(string)
    datastore_id     = optional(string)
    iso_path         = optional(string)
    operating_system = optional(string)
  })))
}

# -----------------------------------------------------------------------------
# Optional: CA Certificate Path
# -----------------------------------------------------------------------------
variable "ca_cert_path" {
  description = "Path to root CA certificate file"
  type        = string
  default     = ""
}
