#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH
# Install user configured/requested packages
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if hass.config.has_value 'packages'; then
    apk update \
        || hass.die 'Failed updating Alpine packages repository indexes'

    for package in $(hass.config.get 'packages'); do
        apk add "$package" \
            || hass.die "Failed installing package ${package}"
    done
fi
