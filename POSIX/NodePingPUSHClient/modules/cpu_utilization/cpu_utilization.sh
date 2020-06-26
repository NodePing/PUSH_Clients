#!/usr/bin/env sh

# Get CPU utilization

id_column=$(vmstat | tail -n2 | awk -F ' ' '{for (i=1; i<= NF; ++i) print i, $i; exit}' | grep id | awk '{printf $1}')
idle=$(vmstat 1 2 | tail -n1 | awk -v id_column=$id_column '{printf $id_column}')

echo $(( 100 - $idle ))
