ARG BUILD_FROM=hassioaddons/base-amd64
FROM ${BUILD_FROM}

# Add env
ENV TERM="xterm-256color"

# Copy data
COPY files/run.sh /
COPY files/hassio /usr/bin/
COPY files/sshd_config /etc/ssh/
COPY files/motd /etc/
COPY files/.zshrc /root/
COPY files/.tmux.conf /root/
COPY files/wheel /etc/sudoers.d/

# Setup base
RUN apk add --no-cache jq openssh sudo zsh openssl libxml2-utils ncurses \
    curl wget net-tools bind-tools rsync git nmap wget awake \
    nano vim mosquitto-clients mariadb-client tmux && \
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    chmod a+x /run.sh /usr/bin/hassio && \
    sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd && \
    touch /etc/ssh/authorized_keys && \
    chmod 0644 /etc/ssh/authorized_keys && \
    touch /var/log/btmp && \
    chmod 0600 /var/log/btmp

CMD [ "/run.sh" ]

# Build arugments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="SSH add-on for Hass.io" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Hass.io SSH add-on for ${BUILD_ARCH}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://addons.community" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-ssh/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-ssh" \
    org.label-schema.vendor="Community Hass.io Addons"
