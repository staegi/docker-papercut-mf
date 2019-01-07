FROM hp41/papercut-mf 
LABEL maintainer="Thomas Stägemann <staegi@github>"
LABEL description="PaperCut MF Application Server"

# Downloading and installing MySQL connector
ENV MYSQL_CONNECTOR_VERSION 8.0.13
ENV MYSQL_CONNECTOR_DOWNLOAD_URL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz

RUN curl -L "${MYSQL_CONNECTOR_DOWNLOAD_URL}" -o /tmp/mysql.tar.gz \
	&& tar -xvzf /tmp/mysql.tar.gz -C /tmp/ \
    && cp /tmp/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar /papercut/server/lib-ext/

# Downloading and installing envsubst
ENV ENVSUBST_DOWNLOAD_URL https://github.com/a8m/envsubst/releases/download/v1.1.0/envsubst-Linux-x86_64

RUN curl -L "${ENVSUBST_DOWNLOAD_URL}" -o /usr/local/bin/envsubst \
    && chmod +x /usr/local/bin/envsubst

COPY server.properties.env /papercut/server/server.properties.env
RUN sed -i '22i    runuser -p papercut -c "envsubst < /papercut/server/server.properties.env > /papercut/server/server.properties"' /entrypoint.sh
RUN sed -i '23i    runuser -l papercut -c "/papercut/server/bin/linux-x64/db-tools init-db -q"' /entrypoint.sh



