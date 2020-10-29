ARG BUILD_FROM=hassioaddons/base:8.0.5
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
        cmake=3.17.2-r0 \
        docker=19.03.12-r0 \
        json-c-dev=0.14-r1 \
        libffi-dev=3.3-r2 \
        libuv-dev=1.38.1-r0 \
        openssl-dev=1.1.1g-r0 \
        python3-dev=3.8.5-r0 \
        zlib-dev=1.2.11-r3 \
    \
    && apk add --no-cache \
        ack=3.3.1-r0 \
        alsa-plugins-pulse=1.2.2-r1 \
        alsa-utils=1.2.2-r0 \
        awake=1.0-r4 \
        bash-completion=2.10-r0 \
        bind-tools=9.16.6-r0 \
        bluez=5.54-r5 \
        colordiff=1.0.19-r0 \
        device-mapper-libs=2.02.186-r1 \
        docker-bash-completion=19.03.12-r0 \
        docker-zsh-completion=19.03.12-r0 \
        git=2.26.2-r0 \
        htop=2.2.0-r0 \
        json-c=0.14-r1 \
        libltdl=2.4.6-r7 \
        libuv=1.38.1-r0 \
        libxml2-utils=2.9.10-r5 \
        mariadb-client=10.4.15-r0 \
        mosh=1.3.2-r14 \
        mosquitto-clients=1.6.9-r0 \
        nano-syntax=4.9.3-r0 \
        nano=4.9.3-r0 \
        ncurses=6.2_p20200523-r0 \
        net-tools=1.60_git20140218-r2 \
        networkmanager=1.24.2-r0 \
        nmap=7.80-r2 \
        openssh=8.3_p1-r0 \
        openssl=1.1.1g-r0 \
        pwgen=2.08-r1 \
        pulseaudio-utils=13.0-r10 \
        py3-pip=20.1.1-r0 \
        python3=3.8.5-r0 \
        rsync=3.1.3-r3 \
        sqlite=3.32.1-r0 \
        sudo=1.9.0-r0 \
        tmux=3.1b-r0 \
        vim=8.2.0735-r0 \
        wget=1.20.3-r1 \
        zip=3.0-r8 \
        zsh-autosuggestions=0.6.4-r0 \
        zsh-syntax-highlighting=0.7.1-r0 \
        zsh=5.8-r1 \
    \
    && git clone --depth 1 \
        git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    \
    && curl -L -s -o /usr/bin/ha \
        "https://github.com/home-assistant/cli/releases/download/4.7.0/ha_${BUILD_ARCH}" \
    \
    && chmod a+x /usr/bin/ha \
    && ha completion > /usr/share/bash-completion/completions/ha \
    \
    && sed -i -e "s#bin/ash#bin/zsh#" /etc/passwd \
    \
    && git clone --branch "v3.2.3" --depth=1 \
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
    && git clone --branch master --single-branch \
        https://github.com/tsl0922/ttyd.git /tmp/ttyd \
    && git -C /tmp/ttyd checkout 1.6.1 \
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
        --find-links "https://wheels.home-assistant.io/alpine-3.12/${BUILD_ARCH}/" \
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
    org.opencontainers.image.title="SSH & Web Terminal" \
    org.opencontainers.image.description="SSH & Web Terminal access to your Home Assistant instance" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-ssh" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-ssh/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
