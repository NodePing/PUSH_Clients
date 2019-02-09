#!/usr/bin/env sh

# Checks the status of APC battery banks. Requires apcupsd is installed
# and the apcaccess command is available. If the state changes to
# something other than ONLINE, a fail is sent.

status=$(apcaccess status | grep "STATUS" | awk '{printf $3}' | xargs)

if [ "$status" = "ONLINE" ]; then
    echo "1"
else
    echo "0"
fi
