ARG BUILD_FROM=hassioaddons/base:5.0.1
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
        bsd-compat-headers=0.7.1-r0 \
        build-base=0.5-r1 \
        cmake=3.14.5-r0 \
        docker=18.09.8-r0 \
        json-c-dev=0.13.1-r0 \
        libffi-dev=3.2.1-r6 \
        openssl-dev=1.1.1d-r0 \
        python3-dev=3.7.5-r1 \
        zlib-dev=1.2.11-r1 \
    \
    && apk add --no-cache \
        ack=3.0.0-r0 \
        awake=1.0-r3 \
        bind-tools=9.14.3-r0 \
        bluez=5.50-r3 \
        colordiff=1.0.18-r1 \
        device-mapper-libs=2.02.184-r0 \
        git=2.22.0-r0 \
        json-c=0.13.1-r0 \
        libltdl=2.4.6-r6 \
        libxml2-utils=2.9.9-r2 \
        lua-resty-http=0.13-r0 \
        mariadb-client=10.3.18-r0 \
        mosh=1.3.2-r8 \
        mosquitto-clients=1.6.3-r0 \
        nano-syntax=4.3-r0 \
        nano=4.3-r0 \
        ncurses=6.1_p20190518-r0 \
        net-tools=1.60_git20140218-r2 \
        networkmanager=1.18.1-r2 \
        nginx-mod-http-lua=1.16.1-r0 \
        nginx=1.16.1-r0 \
        nmap=7.70-r3 \
        openssh=8.1_p1-r0 \
        openssl=1.1.1d-r0 \
        pwgen=2.08-r0 \
        python3=3.7.5-r1 \
        rsync=3.1.3-r1 \
        sqlite=3.28.0-r1 \
        sudo=1.8.27-r0 \
        tmux=2.9a-r0 \
        vim=8.1.1365-r0 \
        wget=1.20.3-r0 \
        zip=3.0-r7 \
        zsh-autosuggestions=0.6.1-r0 \
        zsh-syntax-highlighting=0.6.0-r0 \
        zsh=5.7.1-r0 \
    \
    && git clone --depth 1 \
        git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    \
    && curl -L -s -o /usr/bin/hassio \
        "https://github.com/home-assistant/hassio-cli/releases/download/3.1.0/hassio_${BUILD_ARCH}" \
    \
    && sed -i -e "s#bin/ash#bin/zsh#" /etc/passwd \
    \
    && git clone --branch "v3.0.1" --depth=1 \
        https://github.com/warmcat/libwebsockets.git /tmp/libwebsockets \
    \
    && mkdir -p /tmp/libwebsockets/build \
    && cd /tmp/libwebsockets/build \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DLWS_UNIX_SOCK=ON \
    && make \
    && make install \
    \
    && git clone --branch "1.5.0" --depth=1 \
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
    && pip3 install \
        --no-cache-dir \
        --find-links "https://wheels.home-assistant.io/alpine-3.10/${BUILD_ARCH}/" \
        -r /tmp/requirements.txt \
    \
    && apk del --no-cache --purge .build-dependencies \
    \
    && find /usr/local \
        \( -type d -a -name test -o -name tests -o -name '__pycache__' \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    \
    && rm -f -r \
        /etc/nginx \
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
    org.label-schema.description="SSH & Web Terminal access to your Home Assistant instance" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="SSH & Web Terminal" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-ssh-web-terminal/33820?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-ssh/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-ssh" \
    org.label-schema.vendor="Community Hass.io Add-ons"
