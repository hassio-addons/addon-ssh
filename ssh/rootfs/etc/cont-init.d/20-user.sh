#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH
# Sets up a user account
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

declare username
declare password

username=$(hass.config.get 'username')
username=$(hass.string.lower "${username}")

# Create user account if the user isn't root
if [[ "${username}" != "root" ]]; then

    # Create an user account
    adduser -D "${username}" -s "/bin/sh" \
        || hass.die 'Failed creating the user account'

    # Add new user to the wheel group
    adduser "${username}" wheel \
        || hass.die 'Failed adding user to wheel group'

    # Ensure new user switches to root after login
    echo 'exec sudo su -l' > "/home/${username}/.profile" \
        || hass.die 'Failed configuring user profile'
fi

# We need to set a password for the user account
if hass.config.has_value 'password'; then
    password=$(hass.config.get 'password')
else
    # Use a random password in case none is set
    password=$(pwgen 64 1)
fi
chpasswd <<< "${username}:${password}" 2&> /dev/null
