FROM alpine

RUN apk add -U dropbear openvpn \
    && passwd -d root

ENV CLIENT_CONFIG=/app/client.ovpn

ADD . .
RUN ash dropbear-setup.sh

ENTRYPOINT [ "/bin/ash", "./entrypoint.sh"]
