#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Sets up the users .ssh folder to be persistent
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly SSH_USER_PATH=/data/.ssh

if ! hass.directory_exists "${SSH_USER_PATH}"; then
    mkdir -p "${SSH_USER_PATH}" \
        || hass.die 'Failed to create a persistent .ssh folder'

    chmod 700 "${SSH_USER_PATH}" \
        || hass.die 'Failed setting permissions on persistent .ssh folder'
fi

ln -s "${SSH_USER_PATH}" ~/.ssh
