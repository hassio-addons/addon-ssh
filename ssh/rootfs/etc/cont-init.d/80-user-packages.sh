#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Install user configured/requested packages
# ==============================================================================
if bashio::config.has_value 'packages'; then
    apk update \
        || bashio::exit.nok 'Failed updating Alpine packages repository indexes'

    for package in $(bashio::config 'packages'); do
        apk add "$package" \
            || bashio::exit.nok "Failed installing package ${package}"
    done
fi
