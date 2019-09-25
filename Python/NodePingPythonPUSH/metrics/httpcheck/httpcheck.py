#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pycurl
from io import BytesIO
from . import config


def gather_metrics(c):
    """ Puts connection metrics in a dictionary
    """

    stats = {}

    stats.update({"http_code": c.getinfo(pycurl.HTTP_CODE)})
    stats.update({"time_namelookup": c.getinfo(pycurl.NAMELOOKUP_TIME)})
    stats.update({"time_connect": c.getinfo(pycurl.CONNECT_TIME)})
    stats.update({"time_appconnect": c.getinfo(pycurl.APPCONNECT_TIME)})
    stats.update({"time_pretransfer": c.getinfo(pycurl.PRETRANSFER_TIME)})
    stats.update({"time_redirect": c.getinfo(pycurl.REDIRECT_TIME)})
    stats.update({"time_starttransfer": c.getinfo(pycurl.STARTTRANSFER_TIME)})
    stats.update({"time_total": c.getinfo(pycurl.TOTAL_TIME)})

    return stats


def do_httpcheck():
    """
    """

    buffer = BytesIO()
    c = pycurl.Curl()
    c.setopt(c.URL, config.url)
    c.setopt(c.WRITEDATA, buffer)

    if config.http_method.upper() == "POST":
        c.setopt(c.POST, 1)
        c.setopt(c.HTTPHEADER, ['Content-Type: %s' % config.content_type])
        c.setopt(c.POSTFIELDS, config.data)
    elif config.http_method.upper() == "PUT":
        c.setopt(c.UPLOAD, 1)
        c.setopt(c.HTTPHEADER, ['Content-Type: %s' % config.content_type])
        buffer = BytesIO(config.data.encode('utf-8'))
        c.setopt(c.READDATA, buffer)

    c.perform()

    stats = gather_metrics(c)

    c.close()

    return stats


def main(system, logger):
    """ Gathers metrics of an HTTP connction via POST, PUT, or GET
    """

    return do_httpcheck()
