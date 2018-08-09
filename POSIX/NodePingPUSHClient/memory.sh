#!/usr/bin/env sh

os=$(uname)

if [ $os = "Linux" ]; then
    free -m | awk 'NR==2{printf "%s", $4 }'
else
    if [ $os = "FreeBSD" ]; then
	top -d1 | grep Mem | awk '{ print $10 }' | sed 's/[^0-9]*//g'
    else
	if [ $os = "OpenBSD" ]; then
	    top -d1 | grep Mem | awk '{ print $6 }' | sed 's/[^0-9]*//g'
	fi
    fi
fi
