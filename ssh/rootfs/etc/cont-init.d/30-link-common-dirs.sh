#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH
# Links some common directories to the user's home folder for convenience
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly -a directories=(addons backup config share ssl)

for dir in "${directories[@]}"; do
    ln -s "/${dir}" "${HOME}/${dir}" \
        || hass.log.warning "Failed linking common directory: ${dir}"
done
