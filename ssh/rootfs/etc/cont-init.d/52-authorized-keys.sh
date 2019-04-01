#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Sets up the authorized SSH keys
# ==============================================================================
# SSH authorized_keys files
readonly SSH_AUTHORIZED_KEYS_PATH=/etc/ssh/authorized_keys

# Don't execute this when SSH is disabled
if bashio::config.false 'ssh.enable'; then
    exit 0
fi

if bashio::config.has_value 'ssh.authorized_keys'; then
    while read -r key; do
        if bashio::is_secret "${key}"; then
            key=$(bashio::secret "${key}")
        fi
        echo "${key}" >> "${SSH_AUTHORIZED_KEYS_PATH}"
    done <<< "$(bashio::config 'ssh.authorized_keys')"
fi
