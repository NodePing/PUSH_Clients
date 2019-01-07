#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Pings IPs that are specified and returns 1 if it is up, or 0 if
it is not able to ping. Provide any single IP address (or addresses)
in the IP_ADDRESSES variable below. The program is not asynchronous due
to the restraints of Python 2. More pings will result in a delayed response.
Useful for pinging computers that are hidden behind a firewall.
"""

import asyncio
import socket
import subprocess
from . import _utils


######################### USER DEFINED VARIABLES #########################

# List of addresses or hostnames to be pinged
PING_HOSTS = ["192.168.10.1", "mydomain.com", "fe80::123:abc:543:1"]
# Number of times to ping each address
PING_COUNT = "2"
# How long to wait in seconds if a ping is failing
TIMEOUT = "2"

PING_RESULTS = {}

##########################################################################


def is_ipv6(host):
    """
    Checks if address is IPv6, and returns true if matches regex
    """
    try:
        check = bool(socket.inet_pton(socket.AF_INET6, host))
    except socket.error:
        check = False

    return check


@asyncio.coroutine
def ping_hosts(hostname, ping_count, timeout, system):
    """Pings a single host

    Pinghost a host as an asynchronous coroutine. Written to be
    tested and compatible with Python 3.4+
    """

    if is_ipv6(hostname):
        if system == "Windows":
            command = "ping -6 -n " + \
                str(ping_count) + " -w " + \
                str(timeout) + " " + str(hostname)
        elif system == "OpenBSD":
            command = "ping6 -c " + \
                str(ping_count) + " -w " + \
                str(timeout) + " -q " + str(hostname)
        else:
            command = "ping6 -c " + \
                str(ping_count) + " -W " + \
                str(timeout) + " -q " + str(hostname)
    else:  # if address is IPv4
        if system == "Windows":
            command = "ping -n " + \
                str(ping_count) + " -w " + \
                str(timeout) + " " + str(hostname)
        elif system == "OpenBSD":
            command = "ping -c " + \
                str(PING_COUNT) + " -w " + \
                str(TIMEOUT) + " -q " + str(hostname)
        else:
            command = "ping -c " + \
                str(PING_COUNT) + " -W " + \
                str(TIMEOUT) + " -q " + str(hostname)

    result = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    yield from asyncio.sleep(0)
    output = result.communicate()[0].decode('utf-8').strip('\n').split()[17]

    # Errors caught by running ping as subprocess convert to 0 for failed ping
    if output == "0%" or output == "0.0%":
        up = 1
    else:
        up = 0

    PING_RESULTS.update({hostname: up})


def main(system, logger):
    """
    Returns List of IPs in PING_HOSTS and their status (1/0)
    """

    servers = list(ping_hosts(server, PING_COUNT, TIMEOUT, system)
                   for server in PING_HOSTS)
    loop = asyncio.get_event_loop()

    loop.run_until_complete(asyncio.wait(servers))
    loop.close

    return _utils.report(PING_RESULTS)
