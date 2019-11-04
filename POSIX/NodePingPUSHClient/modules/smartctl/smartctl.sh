#!/usr/bin/env sh

. $(dirname $0)/smartdrives.sh

sep=''

echo '{'

for drive in $drives; do
    result=$(smartctl -H $drive | grep "test result" | grep -c "PASSED")

    echo "$sep"
    echo -n "\"$drive\":$result"
    sep=','
done

echo '}'
