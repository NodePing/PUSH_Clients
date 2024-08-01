#!/usr/bin/env sh


. $(dirname $0)/pools.sh

sep=''

echo -n '{'

for pool in $pools; do
	status=$(zpool status $pool)
	state=$(echo "$status" | grep -A1 "NAME" | grep -c "ONLINE")
	read=$(echo "$status" | grep -A1 "NAME" | tail -n1 | awk '{print $3}')
	write=$(echo "$status" | grep -A1 "NAME" | tail -n1 | awk '{print $4}')
	checksum=$(echo "$status" | grep -A1 "NAME" | tail -n1 | awk '{print $5}')
	
	if [ $(echo "$status" | grep -c "errors: No known data errors") -eq 1 ]; then
		errors=0
	else
		errors=1
	fi

	echo -n "$sep"
	echo -n "\"$pool\":{\"state\":$state,\"read\":$read,\"write\":$write,\"checksum\":$checksum,\"errors\":$errors}"
	sep=','
done

echo '}'
