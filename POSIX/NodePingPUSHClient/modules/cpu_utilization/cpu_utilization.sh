#!/usr/bin/env sh

# Get CPU utilization

os=$(uname)

if [ "$os" = "Linux" ]; then
    cpu_info=$(top -bn2 | grep "%Cpu" | tail -n1)
    column_count=$(echo $cpu_info | awk -F ' ' '{printf NF; exit}')

    # If the CPU is 100% idle, top doesn't put a space between id, and 100
    # so this adds the space back to not mess with awk
    if [ $column_count -eq 16 ]; then
        cpu_info=$(echo "$cpu_info" | sed 's/ni,100.0/ni, 100.0/g')
    fi

    echo "$cpu_info" | awk '{printf (100 - $8)}'
elif [ "$os" = "FreeBSD" ]; then
    top -d2 | grep "CPU:" | tail -n1 | awk '{print $(NF-1)}' | sed 's/%//g'
fi
