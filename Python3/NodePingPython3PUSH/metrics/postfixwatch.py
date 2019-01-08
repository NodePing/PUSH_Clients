#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Checks the postfix mail.log file for any strings that match
and will report that there is a match when found
"""

import datetime
from . import _utils

LOGFILE = "/home/courtney/Documents/X31/mail/mail.log"

STRFTIME = '%b %_d %H:%M'

STRING_MATCHES = [
    "bounced",
    "hello world",
    "sample text"
]


def parselog(log_list):
    """
    Checks list from the mail.log file to see if there are any
    string matches. If a string matches, a counter is incremented by 1.
    """

    match_counter = 0

    for i in log_list:
        for match in STRING_MATCHES:
            if match in i:
                match_counter += 1

    return match_counter


def find_time_range(maillog):
    """Finds the beginning and end of the log contents
    starting with a certain date"""

    lastlogs = []

    now = datetime.datetime.now()
    format_now = now.strftime(STRFTIME)
    minute_ago = (now - datetime.timedelta(minutes=1)
                  ).strftime(STRFTIME)

    with open(maillog, 'r') as log:
        for line in log:
            if line.startswith(format_now):
                lastlogs.append(line)
            elif line.startswith(minute_ago):
                lastlogs.append(line)

    return lastlogs


def main(system, logger):
    """
    Returns a count of how many occurrences strings were matched in
    the given time interval.
    """

    log_chunk = find_time_range(LOGFILE)
    match_count = parselog(log_chunk)

    return _utils.report(int(match_count))
