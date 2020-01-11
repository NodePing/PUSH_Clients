#!/usr/bin/env sh

os=$(uname)

if [ $os = "Linux" ]; then
    free -m | awk 'NR==2{printf "%s", $4 }'
elif [ $os = "FreeBSD" ]; then
    # FreeBSD 12 changed output of top
    is_11=$(uname -r | grep -o 11)

    if [ -z $is_11 ]; then
	    top -d1 | grep Mem | awk '{ print $8 }' | sed 's/[^0-9]*//g'
    else
        top -d1 | grep Mem | awk '{ print $10 }' | sed 's/[^0-9]*//g'
    fi
elif [ $os = "OpenBSD" ]; then
	top -d1 | grep Mem | awk '{ print $6 }' | sed 's/[^0-9]*//g'
fi
