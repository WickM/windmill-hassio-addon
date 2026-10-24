# check=skip=SecretsUsedInArgOrEnv

# ---------------------------------------------------------------------------
# Windmill as a hassio add-on
# ---------------------------------------------------------------------------
# We wrap the official windmill image (ghcr.io/windmill-labs/windmill,
# AGPL-3.0) with s6-overlay + bashio. Postgres is expected to be provided
# by the HA Postgres/MariaDB addon (pass database_url in config).
# ---------------------------------------------------------------------------

FROM ghcr.io/windmill-labs/windmill:latest

ENV \
    LANG=C.UTF-8 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_VERBOSITY=0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG BUILD_ARCH=amd64
ARG BASHIO_VERSION="v0.18.1"
ARG S6_OVERLAY_VERSION="3.2.1.0"
ARG TEMPIO_VERSION="2024.11.2"

RUN \
    apt-get update && apt-get install -y --no-install-recommends \
        bash curl ca-certificates jq tzdata tar xz-utils \
    && S6_ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "amd64" ]; then S6_ARCH="x86_64"; fi \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" | tar -C / -Jxpf - \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" | tar -C / -Jxpf - \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz" | tar -C / -Jxpf - \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz" | tar -C / -Jxpf - \
    && curl -J -L -o /tmp/bashio.tar.gz "https://github.com/hassio-addons/bashio/archive/${BASHIO_VERSION}.tar.gz" \
    && mkdir -p /tmp/bashio-extract /usr/lib/bashio \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio-extract \
    && mv /tmp/bashio-extract/lib /usr/lib/bashio/lib \
    && ln -sf /usr/lib/bashio/lib/bashio /usr/bin/bashio \
    && curl -L -s -o /usr/bin/tempio "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}" \
    && chmod a+x /usr/bin/tempio \
    && apt-get purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/* /tmp/*

COPY rootfs /

ENTRYPOINT ["/init"]
CMD []

ARG BUILD_VERSION BUILD_DATE BUILD_DESCRIPTION BUILD_NAME BUILD_REF BUILD_REPOSITORY
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="Manuel <https://github.com/WickM>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Windmill Hass.io Add-on" \
    org.opencontainers.image.licenses="AGPL-3.0" \
    org.opencontainers.image.url="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}"