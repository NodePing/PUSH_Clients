#!/usr/bin/env sh


. $(dirname $0)/pools.sh

sep=''

echo '{'

zpool_status=$(zpool status | grep -A1 "pool:")

for pool in $pools; do
    state=$(echo $zpool_status | grep -A1 $pool | grep -c "ONLINE")

    echo "$sep"
    echo -n "\"$pool\":$state"
    sep=','
done

echo '}'
