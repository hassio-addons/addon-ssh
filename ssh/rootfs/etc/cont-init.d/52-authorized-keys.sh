#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Sets up the authorized SSH keys
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

# SSH authorized_keys files
readonly SSH_AUTHORIZED_KEYS_PATH=/etc/ssh/authorized_keys

# Don't execute this when SSH is disabled
if hass.config.false 'ssh.enable'; then
    exit 0
fi

if hass.config.has_value 'ssh.authorized_keys'; then
    while read -r key; do
        echo "${key}" >> "${SSH_AUTHORIZED_KEYS_PATH}"
    done <<< "$(hass.config.get 'ssh.authorized_keys')"
fi
