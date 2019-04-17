#!/usr/bin/env sh

hash_type="$(cat $(dirname $0)/checksum_type.txt)"
checksums_file="$(dirname $0)/checksum.txt"

OS=$(uname)

sep=''

if [ $OS = "Linux" ]; then
    if [ $hash_type = "sha1" ]; then
	command="sha1sum"
    elif [ $hash_type = "sha256" ]; then
	command="sha256sum"
    elif [ $hash_type = "sha512" ]; then
	command="sha512sum"
    elif [ $hash_type = "md5" ]; then
	command="md5sum"
    else
	command="sha256sum"
    fi
elif [ $OS = "FreeBSD" ] || [ $OS = "OpenBSD" ]; then
    if [ $hash_type = "sha1" ]; then
	command="sha1"
    elif [ $hash_type = "sha256" ]; then
	command="sha256"
    elif [ $hash_type = "sha512" ]; then
	command="sha512"
    elif [ $hash_type = "md5" ]; then
	command="md5"
    else
	command="sha256"
    fi
fi

echo '{'

cat $checksums_file | while read -r line; do
    name=$(echo $line | awk '{printf $1}')
    checksum=$(echo $line | awk '{printf $2}')

    echo "$sep"

    if [ -f $name ]; then
	if [ $OS = "Linux" ]; then
	    run_sum=$($command $name | awk '{printf $1}')
	elif [ $OS = "FreeBSD" ] || [ $OS = "OpenBSD" ]; then
	    run_sum=$($command $name | awk '{printf $4}')
	fi

	if [ "$run_sum" = "$checksum" ]; then
	    echo -n "\"$name\":1"
	else
	    echo -n "\"$name\":0"
	fi
    else
	echo -n "\"$name\":0"
    fi

    sep=','
    
done

echo '}'
    
