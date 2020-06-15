FROM alpine

RUN apk add -U dropbear openvpn \
    && passwd -d root

ADD . .
RUN ash dropbear-setup.sh

ENTRYPOINT [ "/bin/ash", "./entrypoint.sh"]
