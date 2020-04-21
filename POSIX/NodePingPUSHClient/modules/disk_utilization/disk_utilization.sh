#!/usr/bin/env sh

# Finds amount of used disk space per partition

drives=$(df -P | grep -E '^/.*$')

sep=''
echo '{'
echo "$drives" | while read -r line; do

	echo "$sep"
	echo $line | awk '{printf "\"%s\":%.2f", $1, substr($5, 1, length($5)-1)}'
	sep=','
done
echo '}'
