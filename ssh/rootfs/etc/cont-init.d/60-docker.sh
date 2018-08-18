#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Sets up shared sessions between the SSH & Web terminal
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

# Disable SSH & Web Terminal session sharing if configured
if [[ -S "/var/run/docker.sock" ]]; then
    rm /usr/local/bin/docker
    mv /usr/local/bin/.undocked /usr/local/bin/docker
    hass.log.info 'Docker support has been enabled.'
fi
