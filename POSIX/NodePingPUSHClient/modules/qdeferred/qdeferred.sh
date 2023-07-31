#!/usr/bin/env sh

qs=$(qshape deferred | head -n2 | sed 's/TOTAL //g')

data=$(echo $qs | awk '{ for (i=1; i <= 11; i++) print "\"" $i "\":" "\""$(i+11)"\"," }')

echo "{${data%?}}"
