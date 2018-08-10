#!/usr/bin/env sh

#Gathers zfs datasets and finds how much space is free

datasets=$(zfs list -Hp)

sep=''
echo '{'
echo "$datasets" | while read -r line; do

    echo "$sep"
    echo $line | awk '{ printf "\"%s\":%.2f", $1, $3/($2+$3) }'

    sep=','
done
echo "}"
