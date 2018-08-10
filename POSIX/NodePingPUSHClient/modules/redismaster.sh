#!/usr/bin/env sh

# Uses Redis Sentinels to see who the Redis Master server is.

redis_master=""
sentinel_ip=""
port=""

master=$(redis-cli -h $sentinel_ip -p $port SENTINEL get-master-addr-by-name $redis_master)
ip=$(echo $master | cut -f1 -d " ")

echo $ip
