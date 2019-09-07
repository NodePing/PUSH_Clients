#!/usr/bin/env sh

. $(dirname $0)/variables.sh

if [ -z $username ] && [ -z $password ]; then
    returned=$(mongo --eval "$eval_string" | grep -c "$expected_message")
else
    returned=$(mongo --username "$username" --password "$password" --eval "$eval_string" | grep -c "$expected_message")
fi

if [ $returned -gt 0 ]; then
    echo "1"
else
    echo "0"
fi


