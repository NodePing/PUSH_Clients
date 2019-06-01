# IP Address module

## Description

This module checks IP addresses on the host and compares it to a list of acceptable
IP addresses that are supposed to be on the server. This is handy if you want to keep
an eye on unexpected interface changes.

If any unexpected IPs exist, the metric will fail. If not all IPs exist, the metric will fail.

For Linux, works with the new `ip` tool. Tested with `ifconfig` on FreeBSD and OpenBSD,
but should work with any other OS using `ifconfig`

## Configuration

Edit the `acceptable_ips` variable in `variables.sh` by adding IP addresses that
you deem acceptable. Each IP address should be space separated.
