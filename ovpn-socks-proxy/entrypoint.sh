#!/bin/ash

# SSH Server
dropbear -p 22 -B

# VPN Server
openvpn ${CLIENT_CONFIG}
