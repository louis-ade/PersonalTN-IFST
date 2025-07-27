# --- Tailscale Subnet Router VM ---

resource "azurerm_linux_virtual_machine" "subnet_router_vm" {
  name                = "subnet-router-vm-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  network_interface_ids = [
    azurerm_network_interface.subnet_router_nic.id,
  ]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  # Provisioner to install Tailscale and configure as subnet router
  # This runs after the VM is created and reachable via SSH
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y curl",
      # Add Tailscale GPG key and repository
      "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarch.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null",
      "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.tgz | sudo tar -xzf - -C /usr/share/keyrings", # Corrected path and use sudo for tar
      "echo 'deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/ubuntu jammy main' | sudo tee /etc/apt/sources.list.d/tailscale.list",
      "sudo apt update -y",
      "sudo apt install -y tailscale",
      # Enable IP forwarding for subnet router
      "sudo sysctl -w net.ipv4.ip_forward=1",
      "sudo sysctl -w net.ipv6.conf.all.forwarding=1",
      "echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf",
      "echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf",
      # Bring Tailscale up with authkey and advertised routes
      "sudo tailscale up --authkey ${tailscale_device_authorization.subnet_router_auth.id} --accept-routes --advertise-routes=${azurerm_subnet.default.address_prefixes[0]} --accept-dns=false",
    ]
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.subnet_router_pip.ip_address
      user        = var.vm_admin_username
      private_key = file(var.ssh_private_key_path)
      timeout     = "5m"
    }
  }
}



# Use a data source to find the device that just connected via the auth key and is online
data "tailscale_device" "subnet_router_device" {
  name = "subnet-router-${random_string.suffix.result}" # Unique name matching the VM
  depends_on = [
    azurerm_linux_virtual_machine.subnet_router_vm
  ]
}

resource "tailscale_device_authorization" "subnet_router_auth" {
  device_id  = data.tailscale_device.subnet_router_device.node_id
  authorized = true
}

# Enable advertised routes for the subnet router device
resource "tailscale_device_routes" "subnet_router_routes" {
  device_id      = data.tailscale_device.subnet_router_device.id
  routes         = [azurerm_subnet.default.address_prefixes[0]]
  reusable       = true
  wait_for_routes = true
}

# --- Tailscale SSH Device VM ---

resource "azurerm_linux_virtual_machine" "ssh_device_vm" {
  name                = "ssh-device-vm-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  network_interface_ids = [
    azurerm_network_interface.ssh_device_nic.id,
  ]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  # Provisioner to install Tailscale and enable SSH
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y curl",
      # Add Tailscale GPG key and repository
      "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarch.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null",
      "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.tgz | sudo tar -xzf - -C /usr/share/keyrings",
      "echo 'deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/ubuntu jammy main' | sudo tee /etc/apt/sources.list.d/tailscale.list",
      "sudo apt update -y",
      "sudo apt install -y tailscale",
      # Bring Tailscale up with authkey and SSH enabled
      "sudo tailscale up --authkey ${tailscale_device_authorization.ssh_device_auth.id} --ssh --accept-dns=false",
    ]
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.ssh_device_pip.ip_address
      user        = var.vm_admin_username
      private_key = file(var.ssh_private_key_path)
      timeout     = "5m"
    }
  }
}


# Use a data source to find the device that just connected via the auth key and is online
data "tailscale_device" "ssh_device" {
  name = "ssh-device-${random_string.suffix.result}" # Unique name matching the VM
  depends_on = [
    azurerm_linux_virtual_machine.ssh_device_vm
  ]
}

resource "tailscale_device_authorization" "ssh_device_auth" {
  device_id  = data.tailscale_device.ssh_device.node_id
  authorized = true
}

