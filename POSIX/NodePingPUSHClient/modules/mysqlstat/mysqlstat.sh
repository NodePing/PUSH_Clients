#!/usr/bin/env sh

. $(dirname $0)/variables.sh

if [ -z $password ]; then
    data=$(mysql -u"$username" -h "$host"<<EOF
$querystring
EOF
)
else
    data=$(mysql -u"$username" -h "$host" -p"$password"<<EOF
$querystring
EOF
)
fi

count=$(echo $data | awk '{ print $2 }')

if [ $count > 0 ]; then
    echo 1
else
    echo 0
fi
