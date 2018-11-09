#!/usr/bin/env sh

# This module will alert you if a file hasn't been
# modified in the given timeframe that you have chosen

# Each file must have the pattern of '/path/to/file days hours minutes'

file1="/path/to/file1 0 5 0"
file2="/path/to/file2 0 2 30"
file3="/home/courtney/the_wardrobe.tar.gz 10 6 0"

files="$file1;$file2;$file3"

now=$(date +"%s")
OS=$(uname)

sep=''

echo '{'

file_seps=$(echo $files | grep -o ';' | wc -l)

for i in $(seq $(expr $file_seps + 1)); do
    contents=$(echo $files | cut -f $i -d';')
    name=$(echo $contents | awk '{printf $1}')
    days=$(echo $contents | awk '{printf $2}')
    hours=$(echo $contents | awk '{printf $3}')
    minutes=$(echo $contents | awk '{printf $4}')

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
