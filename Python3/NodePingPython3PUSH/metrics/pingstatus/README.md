# pingstatus module

## Description

This module pings every host in a list and returns if the pings were successful
or not for each host.

## Configuration

* Edit the config.py file
  * Enter each host in the ping_hosts list that you wish to ping
  * Set the `ping_count` variable to how many times you want to ping each host.
    More pings = a better view of there being dropped packets, but will take longer to run
  * Set the timeout for how long to wait if a host won't respond. Longer timeout = longer to run
