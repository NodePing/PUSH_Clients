#!/usr/bin/env sh

drives=$(df -P | grep -E '^/.*$')

sep=''
echo '{'
echo "$drives" | while read -r line; do

	echo "$sep"
	echo $line | awk '{printf "\"%s\":%.2f", $6, $4/($3+$4)}'
	
	sep=','
done
echo '}'
