#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Enables Docker by moving the Docker executable in place.
# ==============================================================================
if bashio::var.false "$(bashio::addon.protected)"; then
    rm /usr/local/bin/docker
    mv /usr/local/bin/.undocked /usr/local/bin/docker
    bashio::log.info 'Docker support has been enabled.'
fi
