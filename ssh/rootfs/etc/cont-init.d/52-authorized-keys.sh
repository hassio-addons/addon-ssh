#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH
# Sets up the authorized SSH keys
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

# SSH authorized_keys files
readonly SSH_AUTHORIZED_KEYS_PATH=/etc/ssh/authorized_keys

if hass.config.has_value 'authorized_keys'; then
    while read -r key; do
        echo "${key}" >> "${SSH_AUTHORIZED_KEYS_PATH}"
    done <<< "$(hass.config.get 'authorized_keys')"
fi
