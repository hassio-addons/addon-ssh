#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH
# Sets up ZSH shell
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly ZSH_HISTORY_FILE=/root/.zsh_history
readonly ZSH_HISTORY_PERSISTANT_FILE=/data/.zsh_history

touch "${ZSH_HISTORY_PERSISTANT_FILE}" \
    || hass.die 'Failed creating a persistent ZSH history file'
    
chmod 600 "$ZSH_HISTORY_PERSISTANT_FILE" \
    || hass.die 'Failed setting the correct permissions to the ZSH history file'

ln -s -f "$ZSH_HISTORY_PERSISTANT_FILE" "$ZSH_HISTORY_FILE" \
    || hass.die 'Failed linking the persistant ZSH history file'
