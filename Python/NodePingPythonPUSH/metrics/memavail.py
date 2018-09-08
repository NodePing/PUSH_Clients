#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Gathers how much available memory there is in the system.
For all non-Linux OSes, psutil is required, and will collect available
memory based on how psutil collects this information. For Linux distributions
Available memory is calculated by fetching MemAvailable from /proc/meminfo
if available. If not, it is calculated as MemFree + Cached + Buffers
"""

from . import _utils


def main(system, logger):
    """
    Returns the free memory in the system in MB.
    """

    if system == 'Linux':
        mem_available = 0

        with open('/proc/meminfo') as f:
            for line in f:
                if line.startswith('MemFree'):
                    mem_free = int(line.split(' ')[-2])
                elif line.startswith('Cached'):
                    mem_cache = int(line.split(' ')[-2])
                elif line.startswith('Buffers'):
                    mem_buffers = int(line.split(' ')[-2])
                elif line.startswith('MemAvailable'):
                    mem_available = int(line.split(' ')[-2])
                else:
                    pass

        # If the system is old and does not have MemAvailable
            # memfree + buffers + cache is calculated as fallback
        if mem_available == 0:
            mem_available = mem_free + mem_buffers + mem_cache

        # Must convert kB to MB
        return _utils.report(
            int(float(mem_available * 0.0009765625)))

    else:  # `system in ('FreeBSD', 'Windows')`
        import psutil

        # b -> MB
        return _utils.report(int(psutil.virtual_memory().available / 1000000.0))
