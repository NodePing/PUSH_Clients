#!/usr/bin/env sh

# Set this to true if you want this to calculate a value at every push interval
# e.g. - a 1 minute cron job will estimate the mbps over a 60 second span
each_push="true"

# Number of seconds to calculate. If each_push is true, set this to how many seconds
# between each cron job. If each_push is false, set it to the number of seconds to sleep
# and calculate a value (note this will pause the whole PUSH client for that number of seconds)
sleep_interval=60

# interface(s) to collect network utilization on
interfaces="enp0s5"

# Max Mbps your user uses to calculate % bandwidth being used
# Mbps received
expected_net_utilization_rx=100
# Mbps transferred 
expected_net_utilization_tx=10

# Ignore this variable
interface_info="$(cd $(dirname $0) && pwd)/last_values.txt"
