#!/usr/bin/env sh

# Collects the status of Cassandra servers in a cluster and returns the values such as "UN" and "DN"

cassstatus=$(nodetool status)

sep=''
echo '{'
echo "$cassstatus" | while read -r line; do

    hasip=$(echo $line | awk '{ print $2 }' | egrep '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b' | xargs)
    if [ -n "$hasip" ]; then
        echo "$sep"
        echo $line | awk '{ printf "\"%s\":\"%s\"", $2, $1 }'
        sep=","
    fi
done
echo '}'

