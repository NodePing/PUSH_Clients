#!/usr/bin/env sh

jails=$(jls -h name | awk 'NR>1')
sep=''

echo '{'
echo "$jails" | while read -r line; do

    echo "$sep"
    echo -n "\"$line\": 1"
    #echo $line | awk '{ if($3=="up") printf "\"%s\": 1", $2; else printf "\"%s\": 0", $2; }'

    sep=','
done
echo '}'
