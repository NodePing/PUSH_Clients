#!/usr/bin/env sh

# This module will alert you if a file hasn't been
# modified in the given timeframe that you have chosen

now=$(date +"%s")
OS=$(uname)
file_list="$(dirname $0)/fileage.txt"

sep=''

echo '{'

cat $file_list | while read -r line; do

    name=$(echo $line | cut -f 1 -d " ")
    days=$(echo $line | cut -f 2 -d " ")
    hours=$(echo $line | cut -f 3 -d " ")
    minutes=$(echo $line | cut -f 4 -d " ")

    days_to_sec=$(( $days * 86400 ))
    hrs_to_sec=$(( $hours * 3600 ))
    min_to_sec=$(( $minutes * 60 ))
    total_time=$(( $days_to_sec + $hrs_to_sec + $min_to_sec ))

    echo "$sep"

    if [ -f $name ]; then
    	if [ $OS = "Linux" ]; then
	    last_modify=$(stat -c %Y $name)
	elif [ $OS = "FreeBSD" ]; then
	    last_modify=$(stat -f %a $name)
	elif [ $OS = "OpenBSD" ]; then
	    last_modify=$(stat -f %a $name)
	fi

	time_dif=$(( $now - $last_modify ))

	if [ $time_dif -ge $total_time ]; then
	    echo -n "\"$name\":0"
	elif [ $time_dif -lt $total_time ]; then
	    echo -n "\"$name\":1"
	fi
    else
	echo -n "\"$name\":0"
    fi

    sep=','
    
done

echo '}'
