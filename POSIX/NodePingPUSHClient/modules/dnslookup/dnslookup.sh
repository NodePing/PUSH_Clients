#!/usr/bin/env sh

. $(dirname $0)/variables.sh

if [ -z $dns_ip ]; then
    output=$(host -t $record_type $to_resolve $dns_ip | awk -F' ' '{print $NF}' | xargs)
else
    output=$(host -t $record_type $to_resolve $dns_ip | grep -v "Using domain server" | grep -v "$dns_ip" | grep -v "Aliases" | awk -F' ' '{print $NF}' |  xargs)
fi

if [ $(echo ${#output}) != $(echo ${#expected_output}) ]; then
    echo "0"
    exit
fi

for ip in $expected_output; do
    
    if [ $(echo $output | grep -c $ip) != 1 ]; then
	echo "0"
	exit
    fi
done

echo "1"
