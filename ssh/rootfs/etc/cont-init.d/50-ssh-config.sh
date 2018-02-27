#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH
# Configures the SSH daemon
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly SSH_CONFIG_PATH=/etc/ssh/sshd_config
declare username
declare port

# Port
port=$(hass.config.get 'port')
if hass.config.has_value 'port'; then
    sed -i "s/Port\ .*/Port\ ${port}/" "${SSH_CONFIG_PATH}" \
        || hass.die 'Failed configuring port'
else
    sed -i "s/Port\ .*/Port\ 22/" "${SSH_CONFIG_PATH}" \
        || hass.die 'Failed configuring port'
fi

# SFTP access
if hass.config.true 'sftp'; then
    sed -i '/Subsystem sftp/s/^#//g' "${SSH_CONFIG_PATH}"
    hass.log.notice 'SFTP access is enabled'
fi

# Allow specified user to log in
username=$(hass.config.get 'username')
if [[ "${username}" != "root" ]]; then
    sed -i "s/AllowUsers\ .*/AllowUsers\ ${username}/" "${SSH_CONFIG_PATH}" \
        || hass.die 'Failed opening SSH for the configured user'
else
    sed -i "s/PermitRootLogin\ .*/PermitRootLogin\ yes/" "${SSH_CONFIG_PATH}" \
        || hass.die 'Failed opening SSH for the root user'
fi

# Enable password authentication when password is set
if hass.config.has_value 'password'; then
    sed -i "s/PasswordAuthentication.*/PasswordAuthentication\ yes/" \
        "${SSH_CONFIG_PATH}" \
          || hass.die 'Failed to setup SSH password authentication'
fi

if hass.config.true 'compatibility_mode'; then
    sed -i '/Ciphers\ .*/s/^/#/g' "${SSH_CONFIG_PATH}"
    sed -i '/MACs\ .*/s/^/#/g' "${SSH_CONFIG_PATH}"
    sed -i '/KexAlgorithms\.* /s/^/#/g' "${SSH_CONFIG_PATH}"
    hass.log.notice 'SSH is running in compatibility mode!'
    hass.log.warning 'Compatibility mode is less secure!'
    hass.log.warning 'Please only enable it when you know what you are doing!'
fi

if hass.config.true 'allow_agent_forwarding'; then
    sed -i "s/AllowAgentForwarding.*/AllowAgentForwarding\ yes/" \
        "${SSH_CONFIG_PATH}" \
          || hass.die 'Failed to setup SSH Agent Forwarding'
fi

if hass.config.true 'allow_remote_port_forwarding'; then
    sed -i "s/GatewayPorts.*/GatewayPorts\ yes/" \
        "${SSH_CONFIG_PATH}" \
          || hass.die 'Failed to setup remote port forwarding'
fi

if hass.config.true 'allow_tcp_forwarding'; then
    sed -i "s/AllowTcpForwarding.*/AllowTcpForwarding\ yes/" \
        "${SSH_CONFIG_PATH}" \
          || hass.die 'Failed to setup SSH TCP Forwarding'
fi
