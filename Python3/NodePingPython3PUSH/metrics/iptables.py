#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# iptc, known as python-iptables to pip and package managers
import iptc

from . import _utils


def main(system, logger):
    table = iptc.Table(iptc.Table.FILTER)
    table6 = iptc.Table6(iptc.Table6.FILTER)
    counter = 0
    counter6 = 0

    for chain in table.chains:
        for rule in chain.rules:
            counter += 1

    for chain in table6.chains:
        for rule in chain.rules:
            counter6 += 1

    return _utils.report({"ipv4": counter, "ipv6": counter6})
