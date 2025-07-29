#!/bin/bash
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --authkey=${TAILSCALE_AUTHKEY} --ssh
