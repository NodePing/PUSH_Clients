#!/usr/bin/env sh

. $(dirname $0)/variables.sh

result=$(psql -U $username -c "$querystring")

count=$(echo $result | awk '{ print $3 }')

if [ $count > 0 ]; then
    echo 1
else
    echo 0
fi
