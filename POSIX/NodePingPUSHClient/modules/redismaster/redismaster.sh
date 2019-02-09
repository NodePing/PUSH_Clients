#!/usr/bin/env sh

# Uses Redis Sentinels to see who the Redis Master server is.

. $(dirname $0)/variables.sh

current_master=$(redis-cli -h $sentinel_ip -p $port SENTINEL get-master-addr-by-name $redis_master)
current_ip=$(echo $current_master | cut -f1 -d " ")

if [ "$current_ip" = "$redis_master_ip" ]; then
    echo "1"
else
    echo "0"
fi
