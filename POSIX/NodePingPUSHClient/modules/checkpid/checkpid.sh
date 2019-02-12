#!/usr/bin/env sh

# Checks a list of PID files to see if the file exists or not

pid_files="$(dirname $0)/checkpid.txt"

sep=''
echo '{'

cat $pid_files | while read -r file; do
    echo $sep
    
    if [ -f $file ]; then
        printf "\"%s\": 1" $file
    else
        printf "\"%s\": 0" $file
    fi

    sep=","
done
echo '}'
