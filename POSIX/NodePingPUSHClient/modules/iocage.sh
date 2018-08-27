#!/usr/bin/env sh

jails=$(iocage list -h)
sep=''

echo '{'
echo "$jails" | while read -r line; do

    echo "$sep"
    echo $line | awk '{ if($3=="up") printf "\"%s\": 1", $2; else printf "\"%s\": 0", $2; }'

    sep=','
done
echo '}'
