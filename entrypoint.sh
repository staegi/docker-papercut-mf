#!/bin/bash

# Fixing permissions after any volume mounts.
chown -R papercut:papercut /papercut
chmod +x /papercut/server/bin/linux-x64/setperms
/papercut/server/bin/linux-x64/setperms

# Perform only if Papercut service exists and is executable.
if [[ -x /etc/init.d/papercut ]]; then

    # If database dir has been volume mounted on host the image database will be overwritten
    # and therefore database needs to initialized
    if [[ ! -d /papercut/server/data/internal/derby ]]; then
        runuser -l papercut -c "/papercut/server/bin/linux-x64/db-tools init-db -q -f"
    fi

    # If an import hasn't been done before and a database backup file name
    # 'import.zip' exists, perform import.
    if [[ -f /papercut/import.zip ]] && [[ ! -f /papercut/import.log ]]; then
        runuser -l papercut -c "/papercut/server/bin/linux-x64/db-tools import-db -q -f /papercut/import.zip"
    fi

    echo "Starting Papercut service in console"
    exec /etc/init.d/papercut console
else
    echo "Papercut service not found/executable, maybe the docker image/build got corrupted? Exiting..."
fi