ARG BUILD_FROM=hassioaddons/base-amd64:1.3.3
FROM ${BUILD_FROM}

# Add env
ENV TERM="xterm-256color"

# Setup base
ARG BUILD_ARCH
RUN \
    apk add --no-cache \
        awake \
        bind-tools \
        git \
        libxml2-utils \
        mariadb-client \
        mosquitto-clients \
        nano \
        ncurses \
        net-tools \
        nmap \
        openssh \
        openssl \
        pwgen \
        rsync \
        sudo \
        tmux \
        vim \
        wget \
        zip \
        zsh \
    \
    && git clone --depth 1 \
        git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    \
    && curl -L -s -o /usr/bin/hassio \
        "https://github.com/home-assistant/hassio-cli/releases/download/1.3.0/hassio_${BUILD_ARCH}" \
    \
    && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
    \
    && rm -f -r /tmp/*

# Copy root filesystem
COPY rootfs /

# Build arugments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="SSH - Secure Shell" \
    io.hass.description="Allows SSH connections to your Home Assistant instance" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Allows SSH connections to your Home Assistant instance" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="SSH - Secure Shell" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-ssh/33820?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-ssh/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-ssh" \
    org.label-schema.vendor="Community Hass.io Add-ons"
