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
try:
    import configparser
except ImportError:
    import ConfigParser as configparser

from . import _utils

DIR_PATH = dirname(realpath(__file__))
FILENAME = __file__.replace('py', 'ini').split("/")[-1]
CONFIGFILE = DIR_PATH + "/" + FILENAME


def main(system, logger):
    """
    Connects to the database with sqlalchemy and does a count of
    the different databases as a generic query to test if the
    database is accessible. Query string can be changed by
    modifying the querystring variable
    """

    config = configparser.RawConfigParser()

    if isfile(CONFIGFILE):
        config.read(CONFIGFILE)
    else:
        print "Cannot find config file. Please fill out " + CONFIGFILE
        config.add_section('main')
        config.set('main', 'username', 'mysql')
        config.set('main', 'host', 'localhost')
        config.set('main', 'password', '')
        config.set('main', 'querystring',
                   'SELECT COUNT(*) FROM information_schema.SCHEMATA')
        with open(CONFIGFILE, 'wb') as configfile:
            config.write(configfile)
        message = "Cannot find config file. Please fill out " + CONFIGFILE
        raise Exception(message)

    host = config.get('main', 'host')
    user = config.get('main', 'username')
    password = config.get('main', 'password')
    querystring = config.get('main', 'querystring')

    connection = pymysql.connect(host=str(host),
                                 user=str(user),
                                 password=str(password))

    with connection.cursor() as cursor:
        result = cursor.execute(querystring)

    if result > 0:
        result = 1
    else:
        result = 0

    return _utils.report(result)
