# 1. Fetch the Arch Linux image from the official community repository
resource "incus_image" "arch_image" {
  source_image = {
    remote   = "images"
    protocol = "simplestreams"
    name     = "archlinux/current/cloud/amd64"
  }
}

# 2. Setup the network bridge
# resource "incus_network" "tofubridge" {
#   name = "tofubridge"
#   config = {
#     "ipv4.address"           = "172.16.1.1/24"
#     "ipv4.nat"               = "true"
#     "bridge.hwaddr"          = "random"
#     "security.ip_filtering"  = "true" # Note the naming change: 'ip_filtering' covers both v4 and v6
#     "security.mac_filtering" = "true"
#     # "ipv6.address" = "none"
#   }
# }

# 3. Deploy the Arch Linux container
resource "incus_instance" "arch_container" {
  name    = "custom-arch-server"
  image   = incus_image.arch_image.fingerprint
  type    = "container"
  running = true

  config = {
    # "limits.cpu"    = "2"
    # "limits.memory" = "2GiB"

    # Note: Arch cloud-init images process user-data similarly,
    # but pacman is used internally by cloud-init for package installations.
    # "cloud-init.user-data" = <<-EOF
    "user.user-data" = <<-EOF
      #cloud-config
      users:
        - name: ansible
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          shell: /bin/bash
      package_update: true
      package_upgrade: true
      packages:
        - python
    EOF
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      nictype = "bridged"
      parent  = "incusbr0"
      # parent         = incus_network.tofubridge.name
      # "ipv4.address" = "172.16.1.50"
    }
  }
}