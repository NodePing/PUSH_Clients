#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Gathers free disk space by mountpoint.
"""

import collections
import os
from shutil import disk_usage as diskusage

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
            percent = _utils.truncate(
                1.0 - diskusage(mountpoint).used / diskusage(mountpoint).total)
            result.update({mountpoint: percent})
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
