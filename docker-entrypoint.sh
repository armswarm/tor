#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

_torrc="$(mktemp -t torrc.XXXXXX)"
_template="${TOR_CONFIG_TEMPLATE:-guard}"
cat "/etc/tor/torrc.${_template}.template" | envsubst > "${_torrc}" && exec tor -f "${_torrc}" "$@"
