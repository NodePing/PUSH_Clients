#!/usr/bin/env sh

. $(dirname $0)/variables.sh
template_file="$(dirname $0)/httpcheck.json"

if [ $http_method = "GET" ] || [ $http_method = "DELETE" ]; then
    echo $(curl -X $http_method -w "@$template_file" -o /dev/null -s $url)
elif [ $http_method = "POST" ] || [ $http_method = "PUT" ]; then
    if [ -z "$data" ]; then
	echo $(curl -X $http_method -w "@$template_file" -o /dev/null -s $url)
    else
	echo $(curl -X $http_method -w "@$template_file" -H "Content-Type: $content_type" -o /dev/null -s --data "$data" $url)
    fi
else
    echo 0
fi
