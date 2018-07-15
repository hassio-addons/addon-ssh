#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Sets up shared sessions between the SSH & Web terminal
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

# Disable SSH & Web Terminal session sharing if configured
if hass.config.false 'share_sessions'; then
    hass.log.notice 'Session sharing has been disabled!'
    rm /root/.zprofile
fi
