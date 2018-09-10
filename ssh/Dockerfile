ARG BUILD_FROM=hassioaddons/base:2.1.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add env
ENV TERM="xterm-256color"

# Setup base
ARG BUILD_ARCH
# hadolint ignore=DL3003
RUN \
    echo '@legacy http://dl-cdn.alpinelinux.org/alpine/v3.7/main' >> /etc/apk/repositories \
    \
    && apk add --no-cache --virtual .build-dependencies \
        bsd-compat-headers=0.7.1-r0 \
        build-base=0.5-r1 \
        cmake=3.11.1-r2 \
        docker=18.06.1-r0 \
        json-c-dev=0.13.1-r0 \
        libressl-dev=2.7.4-r0 \
        zlib-dev=1.2.11-r1 \
    \
    && apk add --no-cache \
        ack=2.24-r0 \
        awake=1.0-r2 \
        bind-tools=9.12.1_p2-r0 \
        bluez=5.49-r2 \
        colordiff=1.0.18-r0 \
        device-mapper-libs=2.02.178-r0 \
        git=2.18.0-r0 \
        json-c=0.13.1-r0 \
        libltdl=2.4.6-r5 \
        libwebsockets-dev@legacy=2.4.0-r1 \
        libwebsockets@legacy=2.4.0-r1 \
        libxml2-utils=2.9.8-r0 \
        mariadb-client=10.2.15-r0 \
        mosh=1.3.2-r5 \
        mosquitto-clients=1.4.15-r3 \
        nano-syntax=2.9.8-r0 \
        nano=2.9.8-r0 \
        ncurses=6.1-r0 \
        net-tools=1.60_git20140218-r2 \
        nmap=7.70-r1 \
        openssh=7.7_p1-r2 \
        openssl=1.0.2o-r2 \
        pwgen=2.08-r0 \
        rsync=3.1.3-r1 \
        sqlite=3.24.0-r0 \
        sudo=1.8.23-r2 \
        tmux=2.7-r0 \
        vim=8.1.0115-r0 \
        wget=1.19.5-r0 \
        zip=3.0-r6 \
        zsh-autosuggestions=0.4.2-r0 \
        zsh-syntax-highlighting=0.6.0-r0 \
        zsh=5.5.1-r0 \
    \
    && git clone --depth 1 \
        git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    \
    && curl -L -s -o /usr/bin/hassio \
        "https://github.com/home-assistant/hassio-cli/releases/download/1.3.1/hassio_${BUILD_ARCH}" \
    \
    && sed -i -e "s#bin/ash#bin/zsh#" /etc/passwd \
    \
    && git clone --branch "1.4.0" --depth=1 \
        https://github.com/tsl0922/ttyd.git /tmp/ttyd \
    \
    && mkdir -p /tmp/ttyd/build \
    && cd /tmp/ttyd/build \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
    && make \
    && make install \
    \
    && cp /usr/bin/docker /usr/local/bin/.undocked \
    \
    && rm -f -r /tmp/* \
    && apk del --purge libwebsockets-dev \
    && apk del --purge .build-dependencies

# Copy root filesystem
COPY rootfs /

# Build arugments
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
