ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:10.0.0
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
# hadolint ignore=DL3003
RUN \
    apk add --no-cache --virtual .build-dependencies \
        bsd-compat-headers=0.7.2-r3 \
        build-base=0.5-r2 \
        cmake=3.20.3-r0 \
        docker=20.10.7-r1 \
        json-c-dev=0.15-r1 \
        libffi-dev=3.3-r2 \
        libuv-dev=1.41.0-r0 \
        openssl-dev=1.1.1k-r0 \
        python3-dev=3.9.5-r1 \
        zlib-dev=1.2.11-r3 \
    \
    && apk add --no-cache \
        ack=3.5.0-r1 \
        alsa-plugins-pulse=1.2.2-r1 \
        alsa-utils=1.2.5-r2 \
        awake=1.0-r6 \
        bash-completion=2.11-r4 \
        bind-tools=9.16.16-r2 \
        bluez=5.58-r2 \
        colordiff=1.0.19-r0 \
        device-mapper-libs=2.02.187-r1 \
        docker-bash-completion=20.10.7-r1 \
        docker-zsh-completion=20.10.7-r1 \
        git=2.32.0-r0 \
        htop=3.0.5-r2 \
        json-c=0.15-r1 \
        libltdl=2.4.6-r7 \
        libuv=1.41.0-r0 \
        libxml2-utils=2.9.12-r1 \
        mariadb-client=10.5.11-r0 \
        mosh=1.3.2-r18 \
        mosquitto-clients=2.0.11-r0 \
        nano-syntax=5.7-r2 \
        nano=5.7-r2 \
        ncurses=6.2_p20210612-r0 \
        net-tools=1.60_git20140218-r2 \
        networkmanager=1.30.2-r0 \
        nmap=7.91-r0 \
        openssh=8.6_p1-r2 \
        openssl=1.1.1k-r0 \
        pwgen=2.08-r1 \
        pulseaudio-utils=14.2-r5 \
        py3-pip=20.3.4-r1 \
        python3=3.9.5-r1 \
        rsync=3.2.3-r2 \
        sqlite=3.35.5-r0 \
        sudo=1.9.7_p1-r1 \
        tmux=3.2-r0 \
        vim=8.2.2956-r0 \
        wget=1.21.1-r1 \
        zip=3.0-r9 \
        zsh-autosuggestions=0.7.0-r0 \
        zsh-syntax-highlighting=0.7.1-r0 \
        zsh=5.8-r2 \
    \
    && git clone --depth 1 \
        git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    \
    && curl -L -s -o /usr/bin/ha \
        "https://github.com/home-assistant/cli/releases/download/4.12.3/ha_${BUILD_ARCH}" \
    \
    && chmod a+x /usr/bin/ha \
    && ha completion > /usr/share/bash-completion/completions/ha \
    \
    && sed -i -e "s#bin/ash#bin/zsh#" /etc/passwd \
    \
    && git clone --branch "v4.1.4" --depth=1 \
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
    && git -C /tmp/ttyd checkout 1.6.3 \
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
    && pip3 install \
        --no-cache-dir \
        --find-links "https://wheels.home-assistant.io/alpine-3.14/${BUILD_ARCH}/" \
        -r /tmp/requirements.txt \
    \
    && hass-cli completion bash > /usr/share/bash-completion/completions/hass-cli \
    \
    && apk del --no-cache --purge .build-dependencies \
    \
    && find /usr/local \
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
