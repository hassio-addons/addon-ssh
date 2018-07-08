#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH
# This files check if all user configuration requirements are met
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

# Check if a username is set
if ! hass.config.has_value 'username'; then
    hass.die 'Setting a username is the mandatory!'
fi

# We require at least a password or a authorized key
if ! hass.config.has_value 'authorized_keys' \
    && ! hass.config.has_value 'password';
then
    hass.die 'Configuring a password or authorized keys is mandatory!'
fi

# SFTP only works if the user is root
if hass.config.true 'sftp' \
    && [[ "$(hass.config.get 'username')" != 'root' ]];
then
    hass.die 'You can only enable SFTP when the username is set to "root"'
fi

# Warn about using the root user
if [[ "$(hass.config.get 'username')" = 'root' ]]; then
    hass.log.warning 'Logging in with root use is security wise, a bad idea!'
fi

# Warn about password login
if hass.config.has_value 'password'; then
    hass.log.warning 'Logging in with a password is security wise, a bad idea!'
    hass.log.warning 'Please, consider using a public/private key pair'
fi

# Check if username password as set together
if hass.config.has_value 'username' && ! hass.config.has_value 'password'; then
    hass.die 'You have set an username, but no password!'
fi

if ! hass.config.has_value 'username' && hass.config.has_value 'password'; then
    hass.die 'You have set a password, but no username!'
fi

# Check SSL requirements, if enabled
if hass.config.true 'ssl'; then
    if ! hass.config.has_value 'certfile'; then
        hass.die 'SSL is enabled, but no certfile was specified'
    fi

    if ! hass.config.has_value 'keyfile'; then
        hass.die 'SSL is enabled, but no keyfile was specified'
    fi

    if ! hass.file_exists "/ssl/$(hass.config.get 'certfile')"; then
        hass.die 'The configured certfile is not found'
    fi

    if ! hass.file_exists "/ssl/$(hass.config.get 'keyfile')"; then
        hass.die 'The configured keyfile is not found'
    fi
fi
