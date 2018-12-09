FROM alpine:3.8

ARG TOR_PACKAGE

RUN apk add --no-cache \
        ca-certificates \
        gettext \
        su-exec \
        python3 \
    && apk add --no-cache \
        -X https://ftp.acc.umu.se/mirror/alpinelinux.org/v3.8/main/ \
        -X https://ftp.acc.umu.se/mirror/alpinelinux.org/v3.8/community/ \
        tor=${TOR_PACKAGE} \
    && apk add --no-cache \
        --virtual=.build_deps \
        go \
        git \
        gcc \
        musl-dev \
    && mkdir -p /var/run/tor && chown tor:root /var/run/tor && chmod 0700 /var/run/tor \
    && easy_install-3.6 pip \
    && pip install nyx \
    ## obfs4
    && mkdir /go \
    && export GOPATH=/go \
    && go get git.torproject.org/pluggable-transports/obfs4.git/obfs4proxy \
    && cp $GOPATH/bin/obfs4proxy /usr/local/bin/ \
    ## cleanup
    && apk del .build_deps && rm -rf /go && rm -rf /root/.gnupg/

ADD torrc.*.template /etc/tor/

ADD docker-entrypoint.sh /usr/local/bin/

VOLUME ["/var/run/tor"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
