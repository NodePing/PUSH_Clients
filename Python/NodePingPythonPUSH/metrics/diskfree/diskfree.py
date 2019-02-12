#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Gathers free disk space by mountpoint.
"""

import collections
# `shutil.diskusage` would simplify `percent_used`, but is only available for
# Python 3.3+.
import os

from .. import _utils


def main(system, logger):
    """
    Returns the percentage of disk space free for each mountpoint found. Logs
    any errors such as permission errors.
    """
    result = collections.OrderedDict()
    mountpoints = get_mountpoints(system)

    for mountpoint in mountpoints:
        try:
            result.update({mountpoint: percent_free(mountpoint, system)})
        except OSError as err:
            # We should expect permissions errors to be somewhat common, but
            # this should not be fatal: we can still report on the filesystems
            # we can access
            logger.error('metrics.disks: {err}!'.format(**locals()))

    return result


def get_mountpoints(system):
    """
    Enumerates the physical device mountpoints.
    """
    if system == 'Linux':
        phydevs = []
        with open("/proc/filesystems", "r") as f:
            for line in f:
                if not line.startswith("nodev"):
                    phydevs.append(line.strip())

        mountpoints = []
        with open('/etc/mtab', "r") as f:
            for line in f:
                if line.startswith('none'):
                    continue
                fields = line.split()
                device = fields[0]
                mountpoint = fields[1]
                fstype = fields[2]
                if fstype not in phydevs:
                    continue
                if device == 'none':
                    device = ''
                mountpoints.append(mountpoint)

    else:  # `system in ('FreeBSD', 'Windows')`
        import psutil

        mountpoints = [part.mountpoint for part in psutil.disk_partitions()]

    return mountpoints


def percent_free(mountpoint, system):
    """
    Give a `mountpoint` string, returns the percentage of disk space used as
    a decimal number less than or equal to one, and truncated to two digits.
    """
    if system == 'Windows':
        import psutil

        return _utils.percent_to_decimal(100.0 - float(psutil.disk_usage(mountpoint).percent))

    else:  # `system in (FreeBSD, Linux)`
        st = os.statvfs(mountpoint)
        used = float((st.f_blocks - st.f_bfree) * st.f_frsize)
        total = float(st.f_blocks * st.f_frsize)
        free = total - used
        return _utils.truncate(free / total)
