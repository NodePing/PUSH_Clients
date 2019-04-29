#!/usr/bin/env sh

. $(dirname $0)/variables.sh

sep=''
echo '{'

for remote in $ping_hosts; do
    if [ "$(uname)" = "OpenBSD" ]; then
	result=$(ping -c $ping_count -w $timeout -q $remote 2> /dev/null | grep -oE "[0-9]{1,3}%" | tr -dc '0-9' | xargs)
    else
	result=$(ping -c $ping_count -W $timeout -q $remote 2> /dev/null | grep -oE "[0-9]{1,3}%" | tr -dc '0-9' | xargs)
    fi

    echo "$sep"

    if [ -z $result ]; then
	printf "\"$remote\":0"
    elif [ $result = 0 ]; then
	printf "\"$remote\":1"
    else
        printf "\"$remote\":0"
    fi

    sep=','
done

echo '}'
