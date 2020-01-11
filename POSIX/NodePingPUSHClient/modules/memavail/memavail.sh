#!/usr/bin/env sh

os=$(uname)

if [ $os = "Linux" ]; then
    free -m | awk 'NR==2{printf  "%s", $7 }'
elif [ $os = "FreeBSD" ]; then
    # FreeBSD 12 changed output of top
    is_11=$(uname -r | grep -o 11)

    if [ -z $is_11 ]; then
        top -d1 | grep Mem | awk '{ print $4,$8,$10 }' | sed 's/[^0-9]/ /g' | awk '{ print $1 + $2 + $3 }'
    else
        top -d1 | grep Mem | awk '{ print $4,$8 }' | sed 's/[^0-9]/ /g' | awk '{ print $1 + $2 }'
    fi
elif [ $os = "OpenBSD" ]; then
    top -d1 | grep Mem | awk '{ print $6,$8 }' | sed 's/[^0-9]/ /g' | awk '{ print $1 + $2 }'
fi
