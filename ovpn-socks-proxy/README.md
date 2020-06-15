# OpenVPN Socks Proxy


### Prerequisites

```
export OVPN_DIR=${HOME}/.ovpn
mkdir ${OVPN_DIR} 

# Copy your config file to the directory
cp client.ovpn ${OVPN_DIR}/client.ovpn


# Automate registering credentials for openvpn
echo "auth-user-pass /app/credentials" >> ${OVPN_DIR}/client.ovpn

cat > ${OVPN_DIR}/credentials
<your-username>
<your-password>
```

#### Set up Aliases

```
export OVPN_DIR=${HOME}/.ovpn
alias oServer="docker run -d --rm --name=oServer --env-file=${OVPN_DIR}/credentials -p 22222:22 -p=18888:8080 --cap-add=NET_ADMIN --device /dev/net/tun -v ${OVPN_DIR}:/app thatinfrastructureguy/ovpn-socks-proxy:v0.0.1"
alias oConnect="ssh -q -f -N -p 22222 -D 18888 -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' root@127.0.0.1"
```

#### Configure your Browser

Configure your browser to route traffic through `127.0.0.1:18888`. 

[Check this reference guide](https://linuxize.com/post/how-to-setup-ssh-socks-tunnel-for-private-browsing/#configuring-your-browser-to-use-proxy)


#### Configure your SSH Session

```
ssh -J localhost:22222 -i <priv_key> -p <port> <user>@<destination-host-ip>
```

##### Debugging

```
docker logs oServer
ps aux | grep "ssh -J"
```

##### Stopping Server

```
docker stop oServer
```
