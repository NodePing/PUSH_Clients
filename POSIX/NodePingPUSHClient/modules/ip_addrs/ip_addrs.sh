#!/usr/bin/env sh

. $(dirname $0)/variables.sh

pass=0

os=$(uname)

# TODO: Illumos?
if [ "$os" = "Linux" ]; then
    ips=$(ip -br addr | grep "UP" | xargs | cut -f3- -d ' ')
else
    ips=$(ifconfig | grep "inet" | cut -f2 -d ' ' | xargs)
fi

for ip in $ips; do
    cidr=$(echo $ip | grep -oE '(100$)|/[0-9]{1,3}')

    if [ "$os" = "Linux" ]; then
        ip=$(echo $ip | sed "s#$cidr##g" | xargs)
    fi

    has_ip=$(echo $acceptable_ips | grep -o -m1 -c $ip)

    if [ "$(echo $ip | grep -oE '^fe80')" = "fe80" ]; then
	continue
    elif [ "$ip" = "127.0.0.1" ]; then
	continue
    elif [ "$ip" = "::1" ]; then
	continue
    elif [ $has_ip = 1 ]; then
	pass=1
    elif [ $has_ip = 0 ]; then
	 pass=0
	 break
    fi

    acceptable_ips=$(echo $acceptable_ips | sed "s/$ip//g" | xargs)
done

remainder=$(echo -n $acceptable_ips | wc -c)

if [ $remainder != 0 ]; then
    pass=0
fi

echo $pass
