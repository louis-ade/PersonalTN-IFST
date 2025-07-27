output "resource_group_name" {
  description = "The name of the Azure Resource Group."
  value       = azurerm_resource_group.rg.name
}

output "subnet_router_public_ip_address" {
  description = "The public IP address of the Azure VM acting as the subnet router."
  value       = azurerm_public_ip.subnet_router_pip.ip_address
}

output "subnet_router_tailscale_ip" {
  description = "The Tailscale IP address of the subnet router."
  value       = data.tailscale_device.subnet_router_device.addresses[0]
}

output "subnet_router_tailscale_hostname" {
  description = "The Tailscale hostname of the subnet router."
  value       = data.tailscale_device.subnet_router_device.name
}

output "ssh_device_public_ip_address" {
  description = "The public IP address of the Azure VM acting as the SSH device."
  value       = azurerm_public_ip.ssh_device_pip.ip_address
}

output "ssh_device_tailscale_ip" {
  description = "The Tailscale IP address of the SSH-enabled device."
  value       = data.tailscale_device.ssh_device.addresses[0]
}

output "ssh_device_tailscale_hostname" {
  description = "The Tailscale hostname of the SSH-enabled device."
  value       = data.tailscale_device.ssh_device.name
}

output "tailnet_name" {
  description = "The name of your Tailnet (derived from your Tailscale account)."
  value       = "Your Personal Tailnet" # As before, confirm in Tailscale admin console
}

output "vm_admin_username" {
  description = "The admin username for the Azure VMs."
  value       = var.vm_admin_username
}
