FROM quay.io/armswarm/alpine:3.6

ARG TOR_PACKAGE
ARG ARM_VERSION

RUN apk add --no-cache \
        ca-certificates \
        gettext \
        su-exec \
        curl \
        python \
        tor=${TOR_PACKAGE} \
    && mkdir -p /var/run/tor && chown tor:root /var/run/tor && chmod 0700 /var/run/tor \
    && _tmp="$(mktemp -t -d tor-arm.XXXXXX)" && cd "${_tmp}" \
    && curl -fsS "https://www.atagar.com/arm/resources/static/arm-${ARM_VERSION}.tar.bz2" | tar jx \
    && cd arm && ./install \
    && cd / && rm -rf "${_tmp}"

ADD torrc.*.template /etc/tor/

ADD docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
