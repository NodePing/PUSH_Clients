#!/usr/bin/env sh

CONFIG="./modules/mysqlstat.conf"
# Config file options shouldn't have spaces between the variable
# and value, no quotes should surround the value

# This module has a separate check file in case you need to supply
# a password. If you do, be sure to set the permissions to something
# that is secure like 0400

if [ ! -f $CONFIG ]; then
    touch $CONFIG
    echo "username=" >> $CONFIG
    echo "password=" >> $CONFIG
    echo "host=localhost" >> $CONFIG
    echo "querystring=SELECT COUNT(*) FROM information_schema.SCHEMATA;" >> $CONFIG

    exit
fi

USER=$(grep "username" $CONFIG | cut -f 2- -d "=")
PASSWORD=$(grep "password" $CONFIG | cut -f 2- -d "=")
HOST=$(grep "host" $CONFIG | cut -f 2- -d "=")
# QUERYSTRING="SELECT COUNT(*) FROM information_schema.SCHEMATA;"
QUERYSTRING=$(grep "querystring" $CONFIG | cut -f 2- -d "=")

if [ -z $PASSWORD ]; then
    data=$(mysql -u"$USER" -h "$HOST"<<EOF
$QUERYSTRING
EOF
)
else
    data=$(mysql -u"$USER" -h "$HOST" -p"$PASSWORD"<<EOF
$QUERYSTRING
EOF
)
fi

count=$(echo $data | awk '{ print $2 }')

if [ $count > 0 ]; then
    echo 1
else
    echo 0
fi
