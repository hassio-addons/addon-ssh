#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Configures the SSH daemon
# ==============================================================================
readonly SSH_CONFIG_PATH=/etc/ssh/sshd_config
declare username
declare port

# Don't execute this when SSH is disabled
if bashio::config.false 'ssh.enable'; then
    exit 0
fi

# Port
port=$(bashio::config 'ssh.port')
sed -i "s/Port\\ .*/Port\\ ${port}/" "${SSH_CONFIG_PATH}" \
    || bashio::exit.nok 'Failed configuring port'

# SFTP access
if bashio::config.true 'ssh.sftp'; then
    sed -i '/Subsystem sftp/s/^#//g' "${SSH_CONFIG_PATH}"
    bashio::log.notice 'SFTP access is enabled'
fi

# Allow specified user to log in
username=$(bashio::config 'ssh.username')
username=$(bashio::string.lower "${username}")
if [[ "${username}" != "root" ]]; then
    sed -i "s/AllowUsers\\ .*/AllowUsers\\ ${username}/" "${SSH_CONFIG_PATH}" \
        || bashio::exit.nok 'Failed opening SSH for the configured user'
else
    sed -i "s/PermitRootLogin\\ .*/PermitRootLogin\\ yes/" "${SSH_CONFIG_PATH}" \
        || bashio::exit.nok 'Failed opening SSH for the root user'
fi

# Enable password authentication when password is set
if bashio::config.has_value 'ssh.password'; then
    sed -i "s/PasswordAuthentication.*/PasswordAuthentication\\ yes/" \
        "${SSH_CONFIG_PATH}" \
          || bashio::exit.nok 'Failed to setup SSH password authentication'
fi

# This enabled less strict ciphers, macs, and keyx.
if bashio::config.true 'ssh.compatibility_mode'; then
    sed -i '/Ciphers\ .*/s/^/#/g' "${SSH_CONFIG_PATH}"
    sed -i '/MACs\ .*/s/^/#/g' "${SSH_CONFIG_PATH}"
    sed -i '/KexAlgorithms\.* /s/^/#/g' "${SSH_CONFIG_PATH}"
    bashio::log.notice 'SSH is running in compatibility mode!'
    bashio::log.warning 'Compatibility mode is less secure!'
    bashio::log.warning 'Please only enable it when you know what you are doing!'
fi

# Enable Agent forwarding
if bashio::config.true 'ssh.allow_agent_forwarding'; then
    sed -i "s/AllowAgentForwarding.*/AllowAgentForwarding\\ yes/" \
        "${SSH_CONFIG_PATH}" \
          || bashio::exit.nok 'Failed to setup SSH Agent Forwarding'
fi

# Allow remote port forwarding
if bashio::config.true 'ssh.allow_remote_port_forwarding'; then
    sed -i "s/GatewayPorts.*/GatewayPorts\\ yes/" \
        "${SSH_CONFIG_PATH}" \
          || bashio::exit.nok 'Failed to setup remote port forwarding'
fi

# Allow TCP forewarding
if bashio::config.true 'ssh.allow_tcp_forwarding'; then
    sed -i "s/AllowTcpForwarding.*/AllowTcpForwarding\\ yes/" \
        "${SSH_CONFIG_PATH}" \
          || bashio::exit.nok 'Failed to setup SSH TCP Forwarding'
fi
