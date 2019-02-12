#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Checks the status of your MySQL/MariaDB service to see
if it is accepting queries
NOTE: There is a configuration file with the same name
as this file (with extension of .ini). Please ensure it is
created and that you have proper configurations in this file.
Also make sure the permissions are strong on this file (0400)
for example, since this file will be used to store a password.
Alternatively, create a user that doesn't have database access
but can do a SHOW DATABASES command and count.
Sample query: SELECT COUNT(*) FROM information_schema.SCHEMATA
"""

from os.path import dirname, realpath, isfile
# Requires: Python 2.7 pymysql package
import pymysql.cursors

from . import config


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
    else:
        result = 0

        return result
