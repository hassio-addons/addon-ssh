ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.4
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add env
ENV TERM="xterm-256color"

# Copy Python requirements file
COPY requirements.txt /tmp/

# Setup base
ARG BUILD_ARCH=amd64
# hadolint ignore=DL3003,DL3042
RUN \
    apk add --no-cache --virtual .build-dependencies \
        bsd-compat-headers=0.7.2-r3 \
        build-base=0.5-r3 \
        cmake=3.23.1-r0 \
        docker=20.10.20-r0 \
        json-c-dev=0.16-r0 \
        libffi-dev=3.4.2-r1 \
        libuv-dev=1.44.1-r0 \
        openssl-dev=1.1.1q-r0 \
        python3-dev=3.10.5-r0 \
        zlib-dev=1.2.12-r3 \
    \
    && apk add --no-cache \
        ack=3.5.0-r1 \
        alsa-plugins-pulse=1.2.7.1-r0 \
        alsa-utils=1.2.7-r1 \
        awake=1.0-r7 \
        bash-completion=2.11-r4 \
        bind-tools=9.16.29-r0 \
        bluez=5.65-r0 \
        colordiff=1.0.20-r0 \
        device-mapper-libs=2.02.187-r2 \
        docker-bash-completion=20.10.20-r0 \
        docker-zsh-completion=20.10.20-r0 \
        git=2.36.3-r0 \
        htop=3.2.0-r1 \
        json-c=0.16-r0 \
        libltdl=2.4.7-r0 \
        libuv=1.44.1-r0 \
        libxml2-utils=2.9.14-r1 \
        mariadb-client=10.6.9-r0 \
        mosh=1.3.2-r22 \
        mosquitto-clients=2.0.14-r1 \
        nano-syntax=6.3-r0 \
        nano=6.3-r0 \
        ncurses=6.3_p20220521-r0 \
        net-tools=2.10-r0 \
        networkmanager-cli=1.38.2-r1 \
        nmap=7.92-r2 \
        openssh=9.0_p1-r2 \
        openssl=1.1.1q-r0 \
        pwgen=2.08-r1 \
        pulseaudio-utils=15.0-r2 \
        py3-pip=22.1.1-r0 \
        python3=3.10.5-r0 \
        rsync=3.2.4-r2 \
        sqlite=3.38.5-r0 \
        sudo=1.9.10-r0 \
        tmux=3.2a-r0 \
        vim=8.2.5000-r0 \
        wget=1.21.3-r0 \
        zip=3.0-r9 \
        zsh-autosuggestions=0.7.0-r0 \
        zsh-syntax-highlighting=0.7.1-r2 \
        zsh=5.8.1-r4 \
    \
    && git clone --depth 1 \
        https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    \
    && curl -L -s -o /usr/bin/ha \
        "https://github.com/home-assistant/cli/releases/download/4.21.0/ha_${BUILD_ARCH}" \
    \
    && chmod a+x /usr/bin/ha \
    && ha completion > /usr/share/bash-completion/completions/ha \
    \
    && sed -i -e "s#bin/ash#bin/zsh#" /etc/passwd \
    \
    && git clone --branch "v4.3.2" --depth=1 \
        https://github.com/warmcat/libwebsockets.git /tmp/libwebsockets \
    \
    && mkdir -p /tmp/libwebsockets/build \
    && cd /tmp/libwebsockets/build \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DLWS_IPV6=ON \
        -DLWS_STATIC_PIC=ON \
        -DLWS_UNIX_SOCK=OFF \
        -DLWS_WITH_LIBUV=ON \
        -DLWS_WITH_SHARED=ON \
        -DLWS_WITHOUT_TESTAPPS=ON \
    && make \
    && make install \
    \
    && git clone --branch main --single-branch \
        https://github.com/tsl0922/ttyd.git /tmp/ttyd \
    && git -C /tmp/ttyd checkout "1.7.1" \
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
    && pip3 install -r /tmp/requirements.txt \
    \
    && apk del --no-cache --purge .build-dependencies \
    \
    && find /usr \
        \( -type d -a -name test -o -name tests -o -name '__pycache__' \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    \
    && rm -f -r \
        /root/.cache \
        /root/.cmake \
        /tmp/*

# Copy root filesystem
COPY rootfs /

# Ensure right permissions
RUN \
    chmod 0750 /etc/sudo.conf \
    && chmod 0750 -R /etc/sudoers.d \
    && chmod 0640 /etc/sudoers.d

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
