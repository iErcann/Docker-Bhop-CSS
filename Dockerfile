# LinuxGSM Counter-Strike: Source Dockerfile with BHOP modifications
FROM ghcr.io/gameservermanagers/linuxgsm:ubuntu-24.04
ARG SHORTNAME=css
ENV GAMESERVER=cssserver

WORKDIR /app

# Install game server requirements and additional dependencies
RUN depshortname=$(curl --connect-timeout 10 -s https://raw.githubusercontent.com/GameServerManagers/LinuxGSM/master/lgsm/data/ubuntu-24.04.csv | awk -v shortname="css" -F, '$1==shortname {$1=""; print $0}') \
    && if [ -n "${depshortname}" ]; then \
        echo "**** Install ${depshortname} ****" \
        && apt-get update \
        && apt-get install -y ${depshortname} unzip \
        && apt-get -y autoremove \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    fi

# Create directory structure
RUN mkdir -p \
    /data/serverfiles/cstrike/cfg \
    /data/config-lgsm/cssserver \
    /data/serverfiles/cstrike/addons/sourcemod/data/sqlite

# Copy default configuration files (will be overridden by volumes if provided)
COPY cssserver.cfg /data/serverfiles/cstrike/cfg/cssserver.cfg
COPY startparams.cfg /data/config-lgsm/cssserver/cssserver.cfg
COPY sql/shavit.sq3 /data/serverfiles/cstrike/addons/sourcemod/data/sqlite/shavit.sq3

# Copy init script and mod files
COPY init.sh init.sh
COPY mods/ /mods/
COPY maps/ /data/serverfiles/cstrike/maps
RUN chmod +x init.sh

HEALTHCHECK --interval=1m --timeout=1m --start-period=2m --retries=1 \
    CMD /app/entrypoint-healthcheck.sh || exit 1

RUN date > /build-time.txt

# Run init.sh at build time
RUN ./init.sh

# Modified entrypoint to skip init.sh
ENTRYPOINT ["/bin/bash", "-c", "exec ./entrypoint.sh"]