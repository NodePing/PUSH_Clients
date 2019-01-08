# -*- coding: utf-8 -*-
"""
Helper functions for writing new metric-collecting modules.
"""

import inspect


def report(result):
    """
    Called on a `dict` of metrics results or a single result, creates a new
    dict with a single key, the calling module's name, where the original
    `result` is the value under that key.
    """
    parent, caller = inspect.getmodule(
        inspect.stack()[1][0]).__name__.split('.')
    assert parent == 'metrics', "All metrics modules belong in the 'metrics.*' namespace."

    return {caller: result}


def percent_to_decimal(percent):
    """
    Takes a percentage and turns it into a floating point decimal of length
    two.
    """
    return truncate(percent / 100.0)


def truncate(value):
    """
    Takes a float and truncates it to two decimal points.
    """
    return float('{0:.2f}'.format(value))
