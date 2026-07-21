terraform {
  required_providers {
    incus = {
      source  = "lxc/incus"
      version = ">= 1.1.0"
    }
  }
}

# Configures the Incus provider. By default, it connects to your local Unix socket.
provider "incus" {
  generate_client_certificates = true
  accept_remote_certificate    = true
}