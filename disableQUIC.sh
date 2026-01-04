#!/system/bin/sh
# disableQUIC.sh
# Block outgoing QUIC traffic (prevent clients from using QUIC)
iptables -I OUTPUT -p udp --dport 443 -j DROP

# If acting as a router/gateway for other dev
iptables -I FORWARD -p udp --dport 443 -j DROP
