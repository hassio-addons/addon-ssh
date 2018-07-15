#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Displays a simple notice in the logs as soon as the web terminal or
# SSH daemon is disabled.
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if hass.config.false 'web.enable'; then
    hass.log.notice 'The Web Terminal has been disabled!'
fi

if hass.config.false 'ssh.enable'; then
    hass.log.notice 'The SSH daemon has been disabled!'
fi
