#!/usr/bin/env python3
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
    data = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    output = data.communicate()[0].decode('utf-8').split('\n')

    for i in output:
        if "STATUS" in i:
            if "ONLINE" in i:
                return 1
            else:
                return 0
