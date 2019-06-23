#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import socket
import dns.resolver
import dns.reversename

from . import config

"""
Does a DNS query and passes if the result is what was expected
"""


def main(system, logger):
    """ Does a DNS query and passes if the result is what was expected
    """

    data = []

    host_resolver = dns.resolver.Resolver()
    host_resolver.nameserver = config.dns_ip

    if socket.gethostbyname(config.to_resolve) == config.to_resolve:
        rdns = dns.reversename.from_address(config.to_resolve)
        rdns_str = rdns.to_text()

        answer = host_resolver.query(rdns_str, config.query_type)
        result = answer[0].to_text()

        if result.endswith("."):
            result = result[:-1]

        if result not in config.expected_output:
            return 0

        return 1

    try:
        answer = host_resolver.query(config.to_resolve, config.query_type)
    except dns.exception.Timeout:
        return 0
    else:
        for rdata in answer:
            data.append(rdata.to_text())

    for result in data:
        if result.startswith('"'):
            result = result[1:]
        if result.endswith('"'):
            result = result[:-1]

        if result not in config.expected_output:
            return 0

    return 1
