#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Gathers how much free memory there is in the system.
"""

from . import _utils


def main(system, logger):
    """
    Returns the free memory in the system in MB.
    """
    if system == 'Linux':
        with open('/proc/meminfo') as f:
            for line in f:
                if line.startswith('MemFree'):
                    # Must convert kB to MB
                    return _utils.report(
                        int(float(line.split(' ')[-2]) * 0.0009765625))

    else:  # `system in ('FreeBSD', 'Windows')`
        import psutil

        # b -> MB
        return _utils.report(int(psutil.virtual_memory().free / 1000000.0))
