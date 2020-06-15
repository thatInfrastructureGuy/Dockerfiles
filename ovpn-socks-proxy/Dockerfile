FROM alpine

RUN apk add -U dropbear openvpn \
    && passwd -d root

WORKDIR /app
ENV CLIENT_CONFIG=/app/client.ovpn
ENV SSH_PORT=22

ADD . .
RUN ash run.sh

ENTRYPOINT [ "/bin/ash", "/app/entrypoint.sh"]
