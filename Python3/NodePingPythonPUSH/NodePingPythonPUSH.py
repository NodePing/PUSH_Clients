#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
A tool to gather system metrics and POST them as JSON.
"""

from __future__ import print_function
# `ConfigParser` was renamed `configparser` in Python 3
import collections
import configparser
import functools
# TODO: Change getopt to argparse
# import getopt
import argparse
import importlib
import json
import logging
import logging.handlers
import os
from os.path import dirname, expanduser, isfile, join, realpath

try:
    from urllib.error import URLError
    from urllib.parse import urlparse
    from urllib.request import Request, urlopen
except ImportError:
    from urllib2 import Request, URLError, urlopen
    from urlparse import urlparse
import sys
import tempfile
import time

# Disables byte compile of code which can cause issues with reading config files
sys.dont_write_bytecode = True

CONFIGFILE = 'config.ini'
LOCKFILE = 'gather_metrics.lock'
# Fix backup logfiles in our rotation to 1
BACKUPCOUNT = 1


def locking(function):
    """
    Prevents two instances of this script from running simultaneously. Note
    this is a best effort implementation and may not handle race conditions
    across platforms.
    """
    @functools.wraps(function)
    def locked_function():
        lockfile = join(tempfile.gettempdir(), 'gather_metrics.lock')

        try:
            with open(lockfile) as f:
                pid = f.read()
                panic("Only one instance of this script may run at a time! "
                      "Already running with PID '{pid}'.".format(**locals()))
        except:
            try:
                with open(lockfile, 'w+') as f:
                    f.write(repr(os.getpid()))
            except IOError:
                panic("Failed to open and write PID to lockfile: "
                      "'{lockfile}'.".format(**locals()))
            else:
                function()
            finally:
                os.remove(lockfile)

    return locked_function


@locking
def main():
    """
    Processes the configuration file and command-line options and then
    executes the specified metrics modules, POSTing the results to the
    specified URL as well as logging them. Loops if so configured, else
    exits.
    """
    system = detect_platform()
    config = Config(join(dirname(realpath(expanduser(__file__))), CONFIGFILE))
    logger = get_logger('Logger', config.logfile, config.logsize, logging.INFO)
    err_logger = get_logger('ErrLogger', config.logerror, config.logsize,
                            logging.DEBUG)
    results = collections.OrderedDict()

    while True:
        # Execute each module in `config.modules`. We call the `main()`
        # function of each module passing in the `system` (i.e., 'Linux',
        # 'FreeBSD', or 'Windows') and an error logger that writes to
        # `config.logerror`. The error logger should be used to log non-fatal
        # errors (e.g., maybe one filesystem was unreadable due to permissions
        # errors, but we can still report disk usage for the others.)
        for module in config.modules:
            try:
                entry = module.main(system, err_logger)
            except Exception as err:
                err = '{module.__name__}: {err}!'.format(**locals())
                # Don't halt execution if a single module fails
                if config.showdata or not config.log:
                    print(err, file=sys.stderr)
                if config.log:
                    err_logger.error(err)
            else:
                results.update(entry)

        results = {'data': results}

        if config.showdata:
            print(json.dumps(results))
        else:
            results = post_results(results, config)

        if config.log:
            logger.info(json.dumps(results))

        if config.loop:
            time.sleep(config.frequency)
        else:
            break


def get_logger(name, path, size, level):
    """
    Returns a Logger that logs of severity `level` and above to the specified
    path up to `size` MBs before rotating out to up to `BACKUPCOUNT` files.
    """
    logger = logging.getLogger(name)
    handler = logging.handlers.RotatingFileHandler(
        path,
        maxBytes=size * 1000000,  # MB -> bytes
        backupCount=BACKUPCOUNT)
    logger.setLevel(level)
    logger.addHandler(handler)
    return logger


def post_results(results, config):
    """
    POSTs a JSON `results` string to a URL as specified by a `config` object.
    Updates and returns the `results` to include the status code and JSON
    response by the server.
    """
    try:
        data = json.dumps(results)
        binary_data = data.encode('utf8')
        request = urlopen(
            Request(
                config.url,
                data=binary_data,
                headers={'Content-Type': 'application/json'}))
    except URLError as err:
        panic('Failed to POST results to {config.url}: {err}.'.format(
            **locals()))
    else:
        results['status_code'] = request.getcode()
        results['json_response'] = request.read().decode()

    return results


class Config(object):
    """
    Represents a metrics gathering configuration as set by the configuration
    file and commandline arguments.
    """

    def __init__(self, path):
        """
        Parses and validates the `CONFIGFILE` configuration file, returning a
        `dict`. In case of an error in the configuration file, exits process
        with a relevant message.
        """

        def to_bool(config, section, key):
            try:
                result = config.getboolean(section, key)
            except ValueError:
                panic("The '{section}.{key}' argument in 'config.ini' must be "
                      "'yes' or 'no'.".format(**locals()))
            else:
                return result

        def to_positive_int(config, section, key):
            try:
                result = config.getint(section, key)
                if result <= 0:
                    raise ValueError
            except ValueError:
                panic("The '{section}.{key}' argument in 'config.ini' must be "
                      "an integer greater than 0.".format(**locals()))
            else:
                return result

        self.parse_args()

        ini = configparser.ConfigParser()
        try:
            ini.read(path)
        except Exception as err:
            panic("'config.ini' file missing or invalid: {err}.".format(
                **locals()))

        self.loop = to_bool(ini, 'looping', 'loop')
        if self.loop:
            self.frequency = to_positive_int(ini, 'looping', 'frequency')

        self.log = to_bool(ini, 'logging', 'log')
        if self.log:
            self.logsize = to_positive_int(ini, 'logging', 'logsize')
            self.logfile = realpath(expanduser(ini.get('logging', 'logfile')))
            self.logerror = realpath(
                expanduser(ini.get('logging', 'logerror')))
            for file in (self.logfile, self.logerror):
                file = file if isfile(file) else dirname(file)
                # if not os.access(self.logfile, os.W_OK):
                #     panic(
                #         "File or directory '{file}' not writeable. Please fix "
                #         "permissions or reconfigure 'config.ini' so that "
                #         "'logging.logfile' and 'logging.logerror' both point "
                #         'to writable files/ directories.'.format(**locals()))

        # If `--showdata` is passed in commandline arguments it overrides
        # what's in the `CONFIGFILE`.
        if not getattr(self, 'showdata', False):
            self.showdata = to_bool(ini, 'debug', 'showdata')

        # Server settings
        url = urlparse(ini.get('server', 'url'), 'https')
        self.force_tls = to_bool(ini, 'server', 'force_tls')
        if self.force_tls and url.scheme != 'https':
            panic("The 'server.url' argument in 'config.ini' must be a "
                  "secure HTTPS URL when 'server.force_tls' = 'yes'.")
        id_ = ini.get('server', 'id')
        checktoken = ini.get('server', 'checktoken')
        if not all((id_, checktoken)):
            panic("The 'id' and 'checktoken' arguments in 'config.ini' must "
                  'not be blank.')
        self.url = 'https://{url.path}?id={id_}&checktoken={checktoken}'.format(
            **locals())

        # Metrics modules
        self.modules = []
        for module in ini.options('modules'):
            if to_bool(ini, 'modules', module):
                try:
                    module = importlib.import_module(
                        'metrics.{module}'.format(**locals()))
                except ImportError as err:
                    panic("Could not import module 'metrics.{module}': "
                          "'{err}'.".format(**locals()))
                else:
                    self.modules.append(module)

    def parse_args(self):
        """
        Parses the commandline options passed when executing this module,
        editing the `config` dictionary as needed. Exits process with usage
        information when `-h`/`--help` is passed or invoked with unknown
        options.
        """

        description = """A tool to gather system metrics and POST them as JSON.\n
        For further configuration, see the documentation in 'config.ini'."""

        parser = argparse.ArgumentParser(description=description)
        parser.add_argument('--showdata', dest='showdata', action='store_true', default=False,
                            help="Print JSON data instead of POSTing to remote server (testing)")

        args = parser.parse_args()

        if args.showdata:
            self.showdata = True


def panic(error):
    """
    Prints a `error` to stderr and exits the process with code 1.
    """
    print(error, file=sys.stderr)
    sys.exit(1)


def detect_platform():
    """
    Detects the platform if it's Linux, Windows, or FreeBSD. Exits with a
    relevant error message otherwise.
    """
    if os.name == "nt":
        return 'Windows'
    elif sys.platform.startswith("linux"):
        return 'Linux'
    elif sys.platform.startswith("freebsd"):
        return 'FreeBSD'
    elif sys.platform.startswith("openbsd6"):
        return 'OpenBSD'
    else:
        panic('This tool currently only supports Linux, Windows, FreeBSD, and OpenBSD. '
              "We have detected you're using '{}'".format(sys.platform))


if __name__ == '__main__':
    main()
