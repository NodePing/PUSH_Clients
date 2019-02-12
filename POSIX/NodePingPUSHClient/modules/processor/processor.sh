#!/usr/bin/env sh

uptime | awk '{printf "{\"1min\":%s\"5min\":%s\"15min\":%s}", $(NF-2), $(NF-1), $(NF)}'
