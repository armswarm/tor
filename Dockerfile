FROM quay.io/armswarm/alpine:3.6

ARG TOR_PACKAGE
ARG ARM_VERSION

RUN apk add --no-cache \
        ca-certificates \
        gettext \
        su-exec \
        python \
    && apk add --no-cache \
        -X https://ftp.acc.umu.se/mirror/alpinelinux.org/edge/main/ \
        -X https://ftp.acc.umu.se/mirror/alpinelinux.org/edge/community/ \
        tor=${TOR_PACKAGE} \
    && apk add --no-cache \
        --virtual=.fetch_deps \
        curl \
        gnupg \
    && mkdir -p /var/run/tor && chown tor:root /var/run/tor && chmod 0700 /var/run/tor \
    && _tmp="$(mktemp -t -d tor-arm.XXXXXX)" && cd "${_tmp}" \
    && _dist="arm-${ARM_VERSION}.tar.bz2" \
    && curl -fsSo "${_dist}" "https://www.atagar.com/arm/resources/static/${_dist}" \
    && curl -fsSo "${_dist}.asc" "https://www.atagar.com/arm/resources/static/${_dist}.asc" \
    && gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 68278CC5DD2D1E85C4E45AD90445B7AB9ABBEEC6 \
    && gpg --verify "${_dist}.asc" \
    && tar jxf "${_dist}" \
    && cd arm && ./install \
    && cd / && rm -rf "${_tmp}" \
    && apk del .fetch_deps && rm -rf /root/.gnupg/

ADD torrc.*.template /etc/tor/

ADD docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
