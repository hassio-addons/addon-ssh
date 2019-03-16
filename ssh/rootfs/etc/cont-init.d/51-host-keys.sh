#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Ensures all SSH host keys exists, if not, it will create them
# ==============================================================================
readonly SSH_HOST_RSA_KEY=/data/ssh_host_rsa_key
readonly SSH_HOST_ED25519_KEY=/data/ssh_host_ed25519_key

# Don't execute this when SSH is disabled
if bashio::config.false 'ssh.enable'; then
    exit 0
fi

if ! bashio::fs.file_exists "${SSH_HOST_RSA_KEY}"; then
    bashio::log.notice 'RSA host key missing, generating one...'

    ssh-keygen -t rsa -f "${SSH_HOST_RSA_KEY}" -N "" \
        || bashio::exit.nok 'Failed to generate RSA host key'
fi

if ! bashio::fs.file_exists "${SSH_HOST_ED25519_KEY}"; then
    bashio::log.notice 'ED25519 host key missing, generating one...'
    ssh-keygen -t ed25519 -f "${SSH_HOST_ED25519_KEY}" -N "" \
        || bashio::exit.nok 'Failed to generate ED25519 host key'
fi
