#!/usr/bin/env sh

. $(dirname $0)/variables.sh
template_file="$(dirname $0)/httpcheck.json"

sep=''
echo '{'

for url in $urls; do
    echo "$sep"
    output=$(curl -w "@$template_file" -o /dev/null -s $url)

    echo "\"$url\": $output"

    sep=','
done

echo '}'
