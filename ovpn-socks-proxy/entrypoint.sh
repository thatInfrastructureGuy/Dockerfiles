#!/bin/ash

# SSH Server
dropbear -p 22 -B

# VPN Server
openvpn --config /app/client.ovpn --auth-user-pass /app/credentials
