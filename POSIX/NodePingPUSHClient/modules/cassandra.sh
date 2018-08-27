#!/usr/bin/env sh

# Collects the status of Cassandra servers in a cluster and returns the values such as "UN" and "DN"

cassstatus=$(nodetool status)

sep=''
echo '{'
echo "$cassstatus" | while read -r line; do

    hasip=$(echo $line | awk '{ print $2 }' | egrep '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b' | xargs)
    if [ -n "$hasip" ]; then
        echo "$sep"

        if [ $(echo $line | awk '{ printf $1 }') = "UN" ]; then
            echo $line | awk '{ printf "\"%s\": 1", $2 }'
        else
            echo $line | awk '{ printf "\"%s\": 0", $2 }'
        fi

        sep=","
    fi
done
echo '}'

