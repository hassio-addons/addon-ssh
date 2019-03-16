ARG BUILD_FROM=hassioaddons/base:3.0.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add env
ENV TERM="xterm-256color"

# Copy Python requirements file
COPY requirements.txt /tmp/

# Setup base
ARG BUILD_ARCH
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        build-base=0.5-r1 \
        docker=18.09.1-r0 \
        libffi-dev=3.2.1-r6 \
        openssl-dev=1.1.1b-r1 \
        python3-dev=3.6.8-r1 \
    \
    && apk add --no-cache \
        ack=2.24-r0 \
        awake=1.0-r2 \
        bind-tools=9.12.3-r0 \
        bluez=5.50-r0 \
        colordiff=1.0.18-r0 \
        device-mapper-libs=2.02.182-r0 \
        git=2.20.1-r0 \
        libxml2-utils=2.9.9-r1 \
        mariadb-client=10.3.13-r0 \
        mosh=1.3.2-r7 \
        mosquitto-clients=1.5.6-r0 \
        nano-syntax=3.2-r0 \
        nano=3.2-r0 \
        ncurses=6.1_p20190105-r0 \
        net-tools=1.60_git20140218-r2 \
        nmap=7.70-r3 \
        openssh=7.9_p1-r4 \
        openssl=1.1.1b-r1 \
        pwgen=2.08-r0 \
        python3=3.6.8-r1 \
        rsync=3.1.3-r1 \
        sqlite=3.26.0-r3 \
        sudo=1.8.25_p1-r2 \
        tmux=2.8-r0 \
        ttyd=1.4.2-r1 \
        vim=8.1.0630-r0 \
        wget=1.20.1-r0 \
        zip=3.0-r7 \
        zsh-autosuggestions=0.5.0-r0 \
        zsh-syntax-highlighting=0.6.0-r0 \
        zsh=5.6.2-r0 \
    \
    && git clone --depth 1 \
        git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    \
    && curl -L -s -o /usr/bin/hassio \
        "https://github.com/home-assistant/hassio-cli/releases/download/2.1.0/hassio_${BUILD_ARCH}" \
    \
    && sed -i -e "s#bin/ash#bin/zsh#" /etc/passwd \
    \
    && cp /usr/bin/docker /usr/local/bin/.undocked \
    \
    && pip3 install --no-cache-dir -r /tmp/requirements.txt \
    \
    && rm -f -r /tmp/* \
    && apk del --purge .build-dependencies

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="SSH & Web Terminal" \
    io.hass.description="SSH & Web Terminal access to your Home Assistant instance" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="SSH & Web Terminal access to your Home Assistant instance" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="SSH & Web Terminal" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-ssh-web-terminal/33820?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-ssh/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-ssh" \
    org.label-schema.vendor="Community Hass.io Add-ons"
