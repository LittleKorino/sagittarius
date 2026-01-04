#/system/bin/sh
#runTailscaled.sh

## Run tailscale with state and socket
/data/local/korino/tailscale_1.90.8_arm64/tailscaled \
  --state=/data/local/korino/tailscale-state/tailscaled.state \
  --socket=/data/local/korino/tailscale-state/tailscaled.sock \
  --tun=userspace-networking 
