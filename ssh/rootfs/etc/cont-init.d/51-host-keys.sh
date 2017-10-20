#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH
# Ensures all SSH host keys exists, if not, it will create them
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly SSH_HOST_RSA_KEY=/data/ssh_host_rsa_key
readonly SSH_HOST_ED25519_KEY=/data/ssh_host_ed25519_key

if ! hass.file_exists "${SSH_HOST_RSA_KEY}"; then
    hass.log.notice 'RSA host key missing, generating one...'

    ssh-keygen -t rsa -f "${SSH_HOST_RSA_KEY}" -N "" \
        || hass.die 'Failed to generate RSA host key'
fi

if ! hass.file_exists "${SSH_HOST_ED25519_KEY}"; then
    hass.log.notice 'ED25519 host key missing, generating one...'
    ssh-keygen -t ed25519 -f "${SSH_HOST_ED25519_KEY}" -N "" \
        || hass.die 'Failed to generate ED25519 host key'
fi
