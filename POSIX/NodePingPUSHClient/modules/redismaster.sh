#!/usr/bin/env sh

# Uses Redis Sentinels to see who the Redis Master server is.

# Name of the Redis Master being monitored
redis_master=""
# IP of the Redis Master
redis_master_ip=""
# Sentinel to make a connection to via redis-cli
sentinel_ip=""
# Port to contact the Redis-Sentinel on
port=""

current_master=$(redis-cli -h $sentinel_ip -p $port SENTINEL get-master-addr-by-name $redis_master)
current_ip=$(echo $current_master | cut -f1 -d " ")

if [ "$current_ip" = "$redis_master_ip" ]; then
    echo "1"
else
    echo "0"
fi