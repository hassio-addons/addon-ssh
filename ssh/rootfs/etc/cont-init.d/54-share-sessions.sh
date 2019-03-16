#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Sets up shared sessions between the SSH & Web terminal
# ==============================================================================
# Disable SSH & Web Terminal session sharing if configured
if bashio::config.false 'share_sessions'; then
    bashio::log.notice 'Session sharing has been disabled!'
    rm /root/.zprofile
fi
