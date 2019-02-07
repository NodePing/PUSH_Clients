#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Collects who the Redis Master is at the time
REQUIRES: python-redis v2.9 or higher
"""

from redis.sentinel import Sentinel
from . import config


def main(system, logger):
    """
    Returns the IP address of the current Redis Master
    """

    sentinel = Sentinel(
        [(config.SENTINEL_IP, config.PORT)], socket_timeout=0.1)
    master = sentinel.discover_master(config.REDIS_MASTER)

    if master[0] == config.REDIS_MASTER_IP:
        return int(1)
    else:
        return int(0)
