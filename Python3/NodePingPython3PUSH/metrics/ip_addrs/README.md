# IP Addrs module

## Description

Checks the list of acceptable IP addresses listed in the config.py file and looks if those IP addresses
are present on the system. If there are any extra IP addresses, the metric fails. If there are any IP
addresses missing, the metric will also fail.

## Configuration

* Edit the config.py file and add the list of IP addresses you expect on your system (excluding loopback)
* Install ifaddr
  * Example: python3 -m pip install --user ifaddr
