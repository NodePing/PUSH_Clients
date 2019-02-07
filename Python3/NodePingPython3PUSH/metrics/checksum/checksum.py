#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Looks at the checksum of provided files and sees if they match
the provided checksum for the file. The check will pass if the
checksums match, or fail if the checksums don't match or the
file is missing
"""

import hashlib
from os.path import isfile, dirname, realpath

from . import config


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

    files = config.files
    algorithm = config.hash_algorithm

    for saved_checksum, f in files.items():
        if isfile(f):
            # Hash is collected for each file so user has
            # choice in algorithm per file
            checksum = get_hash(f, algorithm)

            if saved_checksum.upper() == checksum.upper():
                results.update({f: 1})
            else:
                results.update({f: 0})
        else:
            results.update({f: 0})

    return results
