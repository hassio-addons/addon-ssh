#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Sets up ZSH shell
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly ZSH_HISTORY_FILE=/root/.zsh_history
readonly ZSH_HISTORY_PERSISTANT_FILE=/data/.zsh_history
readonly ZSH_ENVIRONMENT_FILE=/root/.zshenv

touch "${ZSH_HISTORY_PERSISTANT_FILE}" \
    || hass.die 'Failed creating a persistent ZSH history file'

chmod 600 "$ZSH_HISTORY_PERSISTANT_FILE" \
    || hass.die 'Failed setting the correct permissions to the ZSH history file'

ln -s -f "$ZSH_HISTORY_PERSISTANT_FILE" "$ZSH_HISTORY_FILE" \
    || hass.die 'Failed linking the persistant ZSH history file'

echo "export HASSIO_TOKEN=\"${HASSIO_TOKEN}\"" > "${ZSH_ENVIRONMENT_FILE}" \
    || hass.die 'Failed to export Hassio API token'
