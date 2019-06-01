#!/usr/bin/env sh

. $(dirname $0)/variables.sh

pass=1

os=$(uname)

# TODO: Illumos?
if [ "$os" = "Linux" ]; then
    ips=$(ip -br addr | grep "UP" | xargs | cut -f3- -d ' ')
else
    ips=$(ifconfig | grep "inet" | cut -f2 -d ' ' | xargs)
fi

for ip in $ips; do
    cidr=$(echo $ip | grep -oE '/[1-9][0-9][0-9]?$|^128$')
    ip=$(echo $ip | sed "s#$cidr##g" | xargs)

    has_ip=$(echo $acceptable_ips | grep -o -m1 -c $ip)

    if [ "$(echo $ip | grep -oE '^fe80')" = "fe80" ]; then
	continue
    elif [ "$ip" = "127.0.0.1" ]; then
	continue
    elif [ "$ip" = "::1" ]; then
	continue
    elif [ $has_ip != 1 ]; then
	pass=0
	break
    fi
done

echo $pass
