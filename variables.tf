variable "resource_group_name" {
  type    = string
  default = "tailscale-rg"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "ssh_public_key_path" {
  type = string
}
