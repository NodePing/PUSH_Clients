#!/usr/bin/env sh

. $(dirname $0)/variables.sh

returned=$(mongo --eval "$eval_string" | grep -c "$expected_message")

if [ $returned -gt 0 ]; then
    echo "1"
else
    echo "0"
fi


