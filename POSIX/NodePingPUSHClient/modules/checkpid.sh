#!/usr/bin/env sh

# Checks a list of PID files to see if the file exists or not

PIDFILE=""

sep=''
echo '{'

for file in $PIDFILE; do
    echo $sep
    
    if [ -f $file ]; then
        printf "\"%s\": 1" $file
    else
        printf "\"%s\": 0" $file
    fi

    sep=","
done
echo '}'
