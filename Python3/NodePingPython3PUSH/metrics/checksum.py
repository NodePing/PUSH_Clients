#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Looks at the checksum of provided files and sees if they match
the provided checksum for the file. The check will pass if the
checksums match, or fail if the checksums don't match or the
file is missing

NOTE: The checksums are stored in a separate checksums.ini
file that SHOULD be kept in a read-only setting to reduce
the chances of any possible checksum tampering.
"""

import configparser
import hashlib
from os.path import isfile, dirname, realpath
from . import _utils

DIR_PATH = dirname(realpath(__file__))
FILENAME = __file__.replace('py', 'ini').split("/")[-1]
CONFIGFILE = DIR_PATH + "/" + FILENAME


def get_hash(f, algorithm):
    """
    Checks the algorithm in the config file to see if it is
    available in hashlib. If so, the checksum is returned
    from that algorithm. Otherwise, an exception is thrown
    """

    # md5(), sha1(), sha224(), sha256(), sha384(), and sha512()
    if algorithm == "md5":
        hasher = hashlib.md5()
    elif algorithm == "sha1":
        hasher = hashlib.sha1()
    elif algorithm == "sha224":
        hasher = hashlib.sha224()
    elif algorithm == "sha256":
        hasher = hashlib.sha256()
    elif algorithm == "sha384":
        hasher = hashlib.sha384()
    elif algorithm == "sha512":
        hasher = hashlib.sha512()
    else:
        hasher = hashlib.sha256()

    with open(f, 'rb') as afile:
        data = afile.read()
        hasher.update(data)
        checksum = hasher.hexdigest()

    return checksum


def main(system, logger):
    """
    Opens config file and checks the checksums provided to
    their corresponding file.
    """

    results = {}

    config = configparser.RawConfigParser()

    if isfile(CONFIGFILE):
        config.read(CONFIGFILE)
    else:
        config.add_section('main')
        config.add_section('settings')
        config.set('main', 'file1', 'checksum # If Windows path, remove :')
        config.set('main', 'file2', 'checksum')
        config.set('settings', 'hash_algorithm', 'sha256')

        with open(CONFIGFILE, 'w') as configfile:
            config.write(configfile)

    files = config.options('main')
    algorithm = config.get('settings', 'hash_algorithm')

    for f in files:
        saved_checksum = config.get('main', f)

        if system == "Windows":
            f = f[:1] + ':' + f[1:]

        if isfile(f):
            # Hash is collected for each file so user has
            # choice in algorithm per file
            checksum = get_hash(f, algorithm)

            if saved_checksum == checksum:
                results.update({f: 1})
            else:
                results.update({f: 0})
        else:
            results.update({f: 0})

    return _utils.report(results)
