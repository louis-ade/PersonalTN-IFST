### `versions.tf`


# Define required Terraform and provider versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Use a compatible version for Azure provider
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "~> 0.14" # Use the latest stable version
    }
    null = { # Used for remote-exec provisioner
      source = "hashicorp/null"
      version = "~> 3.0"
    }
    random = { # Used for unique naming where needed
      source = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Configure the AzureRM provider
provider "azurerm" {
  features {} # Required for the AzureRM provider
  # You can also explicitly define tenant_id, subscription_id here,
  # but `az login` usually handles this through environment variables or shared config.
}

# Configure the Tailscale provider
# Ensure you have set the TAILSCALE_API_KEY environment variable.
# export TAILSCALE_API_KEY="tskey-..."
provider "tailscale" {}
