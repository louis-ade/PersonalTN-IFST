variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "uksouth" # Adjust as needed
}

variable "resource_group_name_prefix" {
  description = "A prefix for the resource group name."
  type        = string
  default     = "tailscale-rg"
}

variable "virtual_network_name_prefix" {
  description = "A prefix for the virtual network name."
  type        = string
  default     = "tailscale-vnet"
}

variable "address_space" {
  description = "The address space for the virtual network (e.g., 10.0.0.0/16)."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_address_prefix" {
  description = "The address prefix for the subnet within the virtual network (e.g., 10.0.0.0/24)."
  type        = string
  default     = "10.0.1.0/24" # Changed from 10.0.0.0/24 to allow for multiple subnets in the future if needed
}

variable "vm_admin_username" {
  description = "The admin username for the Linux VMs."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "The path to your SSH public key file (e.g., ~/.ssh/id_rsa_azure.pub)."
  type        = string

}

variable "ssh_private_key_path" {
  description = "The path to your SSH private key file for remote-exec provisioner (e.g., ~/.ssh/id_rsa_azure)."
  type        = string

}

variable "vm_size" {
  description = "The size of the virtual machines (e.g., Standard_B1s, Standard_DS1_v2)."
  type        = string
  default     = "Standard_B1s" # A small, cost-effective size for testing
}

variable "image_publisher" {
  description = "The publisher of the VM image."
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "The offer of the VM image."
  type        = string
  default     = "0001-com-ubuntu-server-jammy" # Ubuntu Server 22.04 LTS
}

variable "image_sku" {
  description = "The SKU of the VM image."
  type        = string
  default     = "22_04-lts"
}

variable "image_version" {
  description = "The version of the VM image."
  type        = string
  default     = "latest"
}

variable "advertised_routes" {
  description = "The CIDR block of the subnet to advertise via the subnet router. This should typically be the Azure VNet's subnet."
  type        = string
  # Default will be set dynamically based on the subnet created
  # For this specific example, it will be the value of `subnet_address_prefix`
}
