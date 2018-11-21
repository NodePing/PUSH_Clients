#!/usr/bin/env sh

# This module will alert you if a file checksum has
# changed for the specified files. If no hash is provided, defaults to SHA256
# Each file must have the pattern of '/path/to/file checksum'
# Create a "checksum.txt" file in the same directory as this module and
# enter the filename and checksum on a new line each.
# Set the permissions to 0400 when finished adding data.

hash_type="sha256"
hash_file="checksum.txt"
full_path="$(dirname "$(readlink -f $hash_file)")/$hash_file"

OS=$(uname)

sep=''

file_seps=$(echo $files | grep -o ';' | wc -l)

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
elif [ $OS = "FreeBSD" ]; then
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

cat $full_path | while read -r line; do
    name=$(echo $line | awk '{printf $1}')
    checksum=$(echo $line | awk '{printf $2}')

    echo "$sep"

    if [ -f $name ]; then
	if [ $OS = "Linux" ]; then
	    run_sum=$($command $name | awk '{printf $1}')
	elif [ $OS = "FreeBSD" ]; then
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
    
