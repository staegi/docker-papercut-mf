FROM hp41/papercut-mf 
LABEL maintainer="Thomas Stägemann <staegi@github>"
LABEL description="PaperCut MF Application Server"

ENV MYSQL_CONNECTOR_VERSION 8.0.13
ENV MYSQL_CONNECTOR_DOWNLOAD_URL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz

# Downloading and installing MySQL connector 
RUN curl -L "${MYSQL_CONNECTOR_DOWNLOAD_URL}" -o /tmp/mysql.tar.gz \
	&& tar -xvzf /tmp/mysql.tar.gz -C /tmp/ \
    && cp /tmp/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar /papercut/server/lib-ext/

# Create NFS mountable directory with symlinked properies file
RUN mkdir -p /papercut/server/conf \
    && mv /papercut/server/server.properties /papercut/server/conf/server.properties \
    && ln -s /papercut/server/conf/server.properties /papercut/server/server.properties
