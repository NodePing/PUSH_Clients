#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Checks the status of your MySQL/MariaDB service to see
if it is accepting queries
"""

import pymysql.cursors
from os.path import dirname, realpath, isfile

from . import config

# DIR_PATH = dirname(realpath(__file__))
# FILENAME = __file__.replace('py', 'ini').split("/")[-1]
# CONFIGFILE = DIR_PATH + "/" + FILENAME


def main(system, logger):
    """
    Connects to the database with sqlalchemy and does a count of
    the different databases as a generic query to test if the
    database is accessible. Query string can be changed by
    modifying the querystring variable
    """

    host = config.host
    unix_socket = config.unix_socket
    user = config.username
    password = config.password
    querystring = config.querystring

    connection = pymysql.connect(host=str(host),
                                 unix_socket=str(unix_socket),
                                 user=str(user),
                                 password=str(password))

    with connection.cursor() as cursor:
        result = cursor.execute(querystring)

    if result > 0 and not config.return_db_count:
        result = 1

    return result
