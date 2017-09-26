ARG BUILD_FROM=hassioaddons/base-amd64
FROM ${BUILD_FROM}

# Add env
ENV TERM="xterm-256color"

# Copy root filesystem
COPY rootfs /

# Setup base
RUN \
    apk add --no-cache \
        awake \
        bind-tools \
        curl \
        git \
        jq \
        libxml2-utils \
        mariadb-client \
        mosquitto-clients \
        nano \
        ncurses \
        net-tools \
        nmap \
        openssh \
        openssl \
        rsync \
        sudo \
        tmux \
        vim \
        wget \
        wget \
        zsh \
    \
    && git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    \
    && chmod a+x /usr/bin/run.sh /usr/bin/hassio \
    \
    && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
    \
    && touch /etc/ssh/authorized_keys \
    \
    && chmod 0644 /etc/ssh/authorized_keys \
    \
    && touch /var/log/btmp \
    \
    && chmod 0600 /var/log/btmp \
    \
    && rm -f -r \
        /tmp/*

CMD [ "/usr/bin/run.sh" ]

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
    org.label-schema.description="Allows SSH connections to your Home Assistant instance" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Hass.io SSH add-on for ${BUILD_ARCH}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://addons.community" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-ssh/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-ssh" \
    org.label-schema.vendor="Community Hass.io Addons"
