#!/bin/bash
# Ensure your actual key is here.
export TAILSCALE_AUTHKEY="tskey-auth----"

#Install tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Enable IP forwarding 
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf

# Bring Tailscale up with the auth key
tailscale up --authkey=${TAILSCALE_AUTHKEY} --ssh

# --- Subnet Router Configuration (for tailscale-vm-0) ---

HOSTNAME=$(hostname)

if [ "$HOSTNAME" = "tailscale-vm-0" ]; then
  # Advertise the VNet subnet that the VM is part of
  sudo tailscale set --advertise-routes=10.0.1.0/24


  # IMPORTANT: After this, you MUST go to your Tailscale admin console
  # (https://login.tailscale.com/admin/machines) and manually approve
  # the advertised routes for "tailscale-vm-0".
  
