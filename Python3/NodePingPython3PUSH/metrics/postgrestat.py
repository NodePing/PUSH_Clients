#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Checks the status of your PostgreSQL service to see
if it is accepting queries

NOTE: There is a configuration file with the same name
as this file (with extension of .ini). Please ensure it is
created and that you have proper configurations in this file.
Also make sure the permissions are strong on this file (0400)
for example, since this file will be used to store a password.
Alternatively, create a user that doesn't have database access
but can do a SHOW DATABASES command and count.

Sample query: SELECT datname from pg_database
"""

from os.path import dirname, realpath, isfile
# Requires: Python 2.7 psycopg2 package
import psycopg2
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
    Connects to the database with psycopg2 and does a count of
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
        config.set('main', 'dbname', '')
        config.set('main', 'username', 'postgres')
        config.set('main', 'host', 'localhost')
        config.set('main', 'password', '')
        config.set('main', 'querystring', 'SELECT datname from pg_database')
        with open(CONFIGFILE, 'wb') as configfile:
            config.write(configfile)

        message = "Cannot find config file. Please fill out " + CONFIGFILE
        raise Exception(message)

    dbname = config.get('main', 'dbname')
    user = config.get('main', 'username')
    password = config.get('main', 'password')
    host = config.get('main', 'host')
    sql = config.get('main', 'querystring')

    connstring = "dbname='" + dbname + "' user='" + user + \
        "' host='" + host + "' password='" + password + "'"

    try:
        conn = psycopg2.connect(connstring)
        cur = conn.cursor()
        cur.execute(sql)
        result = len(cur.fetchall())
        if result > 0:
            result = 1
    except psycopg2.OperationalError:
        result = 0

    return _utils.report(result)
