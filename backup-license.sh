#!/bin/bash

while true;
do
    sleep 60

	if [[ -f /papercut/server/application.license ]]; then
        runuser -p papercut -c "cp /papercut/server/application.license /papercut/server/data/conf/application.license"
	fi
done
