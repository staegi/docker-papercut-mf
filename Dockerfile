FROM ubuntu:xenial
LABEL maintainer="Hitesh Prabhakar <HP41@github>"
LABEL description="PaperCut MF Application Server"

ENV PAPERCUT_MAJOR_VER 18.x
ENV PAPERCUT_VER 18.0.4
ENV PAPERCUT_DOWNLOAD_URL https://cdn.papercut.com/files/mf/${PAPERCUT_MAJOR_VER}/pcmf-setup-${PAPERCUT_VER}-linux-x64.sh

COPY entrypoint.sh /

RUN \
# Creating 'papercut' user
    useradd -mUd /papercut -s /bin/bash papercut && \
    chmod +x /entrypoint.sh && \

# Installing necessary pacakges and cleaning up
    apt-get update && \
    apt-get install -y \
                    curl \
                    cpio && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \

# Downloading Papercut and ensuring it's executable
    curl -L "${PAPERCUT_DOWNLOAD_URL}" -o /pcmf-setup.sh && \
    chmod a+rx /pcmf-setup.sh && \

# Running the installer as papercut user and running root tasks as root user
    runuser -l papercut -c "/pcmf-setup.sh --non-interactive" && \
    rm -f /pcmf-setup.sh && \
    /papercut/MUST-RUN-AS-ROOT && \

# Stopping Papercut services before capturing image
    /etc/init.d/papercut stop && \
    /etc/init.d/papercut-web-print stop

VOLUME /papercut/server/logs /papercut/server/data/backups /papercut/server/data/conf /papercut/server/data/internal
EXPOSE 9191 9192 9193

ENTRYPOINT ["/entrypoint.sh"]