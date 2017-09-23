#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

_torrc="$(mktemp -t torrc.XXXXXX)"
_template="${TOR_CONFIG_TEMPLATE:-guard}"
chown tor:root /var/lib/tor \
    && chmod 0700 /var/lib/tor \
    && cat "/etc/tor/torrc.${_template}.template" | envsubst > "${_torrc}" \
    && su-exec tor tor -f "${_torrc}" "$@"
