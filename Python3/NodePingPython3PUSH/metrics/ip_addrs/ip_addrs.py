#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Check for all IP addresses on the host. The user supplies
IP addresses that are expected to be there and if IPs are
added or removed, the metric fails
"""

import ifaddr

from . import config


def compare(addrs):
    """
    Compares a list of IP addresses as an argument and compares
    it to a user's list of acceptable IP addresses. If any
    extra addresses exist or if any are missing, a 0 is returned
    """

    acceptable_addrs = config.acceptable_addrs
    acceptable_addrs.sort()
    host_addrs = []

    for addr in addrs:
        if addr not in acceptable_addrs:
            return 0
        else:
            host_addrs.append(addr)

    host_addrs.sort()

    if host_addrs != acceptable_addrs:
        return 0

    return 1


def main(system, logger):
    """
    Gets all IP addresses on interfaces and adds them to
    a list if they aren't local IPs and then compares the
    list of gathered IPs to the list of acceptable IPs
    """

    ips = []
    adapters = ifaddr.get_adapters()

    for adapter in adapters:
        for ip_info in adapter.ips:
            ip = ip_info.ip

            if type(ip) == tuple:
                continue
            if ip == "127.0.0.1" or ip == "127.0.1.1":
                continue
            else:
                ips.append(ip)

    return compare(ips)
