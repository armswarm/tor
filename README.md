# tor

[![Docker Repository on Quay](https://quay.io/repository/armswarm/tor/status "Docker Repository on Quay")](https://quay.io/repository/armswarm/tor)

This repository builds the tor image for ARM.

The image contains a number of template `torrc` files that can be selected using the environment variable `TOR_CONFIG_TEMPLATE`. These template config files are configured using environment variables as well. Please read through the config templates to understand which variables you will need to pass to a container.
