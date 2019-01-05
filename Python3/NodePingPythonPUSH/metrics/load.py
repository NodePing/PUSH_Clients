#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Gathers information about system load (Unix) or CPU utilization (Windows).
"""

import collections
import os

from . import _utils


def main(system, logger):
    """
    Gets the system load average for the last 1, 5, and 15 minutes (Linux and
    FreeBSD). Gets the current CPU usage (Windows).
    """
    result = collections.OrderedDict()

    if system == 'Windows':
        import psutil

        as_percent = psutil.cpu_percent(interval=0.1)
        as_decimal = _utils.percent_to_decimal(as_percent)
        result.update({'usage': as_decimal})

    else:  # `system in ('FreeBSD', 'Linux')`
        for (key, val) in zip(('1min', '5min', '15min'), os.getloadavg()):
            result.update({key: val})

    return _utils.report(result)
