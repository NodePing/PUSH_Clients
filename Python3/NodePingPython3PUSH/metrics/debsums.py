#!/usr/bin/env python3
# -*- coding: utf-8 -*-

###############################################################################
# Reads all files in SUMS_DIR that end in .md5sums and compares the stored
# md5sum for the file with the one that is in the specified directory
# Returns the number, 0 meaning no packages have changed and all is well.
# Needs to be run as root user to properly collect data from debsums.
###############################################################################

import os
import hashlib
from . import _utils

SUMS_DIR = "/var/lib/dpkg/info"


def verify_sums(f):
    """
    Reads filenames from the md5sums file, finds the file, gets its md5sum
    and if they match, then True is set, else False.
    """

    hash_table = {}
    bad_hash_counter = 0

    with open(f, 'r') as f_data:
        contents = f_data.readlines()

    # Stores filename + hash in a dictionary with the hash as the key
    for i in contents:
        i = i.strip('\n')

        i_data = i.split('  ', 1)
        path = "/" + i_data[1]
        i_hash = i_data[0]

        hash_table.update({i_hash: path})

    # Portion that compares the stored hash with the actual hash on disk
    for key, value in hash_table.items():
        path = value
        ahash = key

        # If file doesn't exist, it is counted as a bad hash
        try:
            with open(path, 'rb') as afile:
                data = afile.read()
        except IOError:
            bad_hash_counter += 1
            continue

        hasher = hashlib.md5()
        hasher.update(data)
        digest = hasher.hexdigest()

        if digest != ahash:
            # Some hashes may be changed by another legitimate package
            # This will ignore this record from being counted as a bad hash
            for subkey, subvalue in hash_table.items():
                if subkey == digest:
                    if subvalue == value:
                        pass
                    else:
                        bad_hash_counter += 1
                        break

    return bad_hash_counter


def main(system, logger):
    """
    Returns the count of packages that have been changed
    """

    final_count = 0

    # Looks for all files that end in md5sums
    # Calls function that checks the stored hash with the hash of the file on disk
    for f in os.listdir(SUMS_DIR):
        full_path = os.path.join(SUMS_DIR, f)
        if os.path.isfile(full_path):
            file_ext = full_path.split('.')[-1]

            if file_ext == "md5sums":
                final_count = final_count + verify_sums(full_path)
        else:
            pass

    return _utils.report(final_count)
