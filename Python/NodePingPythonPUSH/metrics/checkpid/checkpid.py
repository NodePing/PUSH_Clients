#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Checks a list of PID files and sees if they exist on the system.
"""

from os.path import isfile

from . import config

PIDFILES = config.PIDFILES


def main(system, logger):
    pidstatus = {}

    for pid in PIDFILES:
        up = 0

        if isfile(pid):
            up = 1
        else:
            up = 0

        pidstatus.update({pid: up})

    return pidstatus
