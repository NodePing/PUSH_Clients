#!/usr/bin/env sh

CONFIG="./modules/pgsqlstat.conf"
# Config file options shouldn't have spaces between the variable
# and value, no quotes should surround the value

# This module has a separate check file in case you need to supply
# a password. If you do, be sure to set the permissions to something
# that is secure like 0400

if [ ! -f $CONFIG ]; then
    touch $CONFIG
    echo "username=postgres" >> $CONFIG
    echo "password=" >> $CONFIG
    echo "querystring=SELECT COUNT(*) datname from pg_database" >> $CONFIG

    exit
fi

USER=$(grep "username" $CONFIG | cut -f 2- -d "=")
PASSWORD=$(grep "password" $CONFIG | cut -f 2- -d "=")
HOST=$(grep "host" $CONFIG | cut -f 2- -d "=")
QUERYSTRING=$(grep "querystring" $CONFIG | cut -f 2- -d "=")
# SELECT COUNT(*) datname from pg_database

# result=$(sudo -u postgres psql -U postgres -h localhost -c "SELECT COUNT(*) datname from pg_database")
result=$(su -c "psql -p \"$PASSWORD\" -c \"$QUERYSTRING\"" postgres)

count=$(echo $result | awk '{ print $3 }')

if [ $count > 0 ]; then
    echo 1
else
    echo 0
fi
