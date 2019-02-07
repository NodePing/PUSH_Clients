#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Checks the status of APC battery banks. Requires apcupsd is installed
and the apcaccess command is available. If the state changes to
something other than ONLINE, a fail is sent.
"""

import subprocess


def main(system, logger):
    """
    Checks the apcups log and checks for any power fail events
    """

    command = "apcaccess status".split()
    data = subprocess.check_output(command).split("\n")

    for i in data:
        if "STATUS" in i:
            status = i.split()[2]

            if status == "ONLINE":
                return 1
            else:
                return 0
