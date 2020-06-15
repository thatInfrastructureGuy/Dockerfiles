#!/bin/ash

echo "${USERNAME}" > pass.txt
echo "${PASSWORD}" >> pass.txt

dropbear -p ${SSH_PORT} -B

openvpn ${CLIENT_CONFIG}
