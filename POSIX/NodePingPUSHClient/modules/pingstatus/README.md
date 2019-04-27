# pingstatus module

## Description

This module will ping all specified hosts and report a 1 if it's up
or a 0 if it's down. This is useful if you wish to ping hosts on
your local network that aren't accessible to the internet.

NOTE: The Python3 client is considerably faster at pinging hosts
since it takes advantage of Python3's asynchronous functionality
to ping many hosts at once, and not one host at a time like the
POSIX client will do.

## Configuration

Set all your hosts in the `ping_hosts` variable as displayed in the sample

`ping_count` - is the number of times each host will be pinged

`timeout` - how many seconds a ping will wait to see if the host is reachable.
After the timeout time, the host will be considered down.
