#!/usr/bin/env sh

# Collects the status of Cassandra servers in a cluster and returns the values such as "UN" and "DN"

cassstatus=$(nodetool status | grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
result=$(echo "$cassstatus" | awk 'NR>1{printf","} {if ($1 == "UN" || $1 == "UJ") printf "\""$2"\": 1"; else printf "\""$2"\": 0" }')
echo "{$result}"
