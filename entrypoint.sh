#!/bin/bash

# Fixing permissions after any volume mounts.
chown -R papercut:papercut /papercut
chmod +x /papercut/server/bin/linux-x64/setperms
/papercut/server/bin/linux-x64/setperms

# Perform only if Papercut service exists and is executable.
if [[ -x /etc/init.d/papercut ]]; then

    # set server config with env vars
    if [[ ! -d /papercut/server/server.properties ]]; then
        echo "Setting server config"
        runuser -p papercut -c "envsubst < /server.properties.template > /papercut/server/server.properties"
    fi

    # database needs to initialized
    echo `runuser -l papercut -c "/papercut/server/bin/linux-x64/db-tools init-db -q"`

    # If an import hasn't been done before and a database backup file name
    # 'import.zip' exists, perform import.
    if [[ -f /papercut/import.zip ]] && [[ ! -f /papercut/import.log ]]; then
        echo `runuser -l papercut -c "/papercut/server/bin/linux-x64/db-tools import-db -q -f /papercut/import.zip"`
    fi

    echo "Starting Papercut service in console"
    exec /etc/init.d/papercut console
else
    echo "Papercut service not found/executable, maybe the docker image/build got corrupted? Exiting..."
fi