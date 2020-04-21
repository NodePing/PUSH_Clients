#!/usr/bin/env sh

# Get CPU utilization
top -bn2 | grep "%Cpu" | tail -n1 | awk '{printf (100 - $8)}'
