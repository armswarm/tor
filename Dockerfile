FROM quay.io/armswarm/alpine:3.6

ARG TOR_PACKAGE

RUN apk add --no-cache \
        ca-certificates \
        gettext \
        su-exec \
        tor=${TOR_PACKAGE}

ADD torrc.*.template /etc/tor/

ADD docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
