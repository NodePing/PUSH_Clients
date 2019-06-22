# IP Address module

## Description

This module checks IP addresses on the host and compares it to a list of acceptable
IP addresses that are supposed to be on the server. This is handy if you want to keep
an eye on unexpected interface changes.

If any unexpected IPs exist, the metric will fail. If not all IPs exist, the metric will fail.

## Configuration

Add IP addresses to the JSON array in ip_addrs.json that are allowed on your
system (excluding loopback addresses)

Example:

[
    "192.168.0.10",
    "192.168.0.15"
]
