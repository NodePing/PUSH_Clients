#!/usr/bin/env sh

. $(dirname $0)/variables.sh
template_file="$(dirname $0)/httpcheck.json"


echo $(curl -w "@$template_file" -o /dev/null -s $url)
