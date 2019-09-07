#!/usr/bin/env python
# -*- coding: utf-8 -*-

import subprocess
from . import config


def main(system, logger):
    """ Runs a mongo query and returns a fail if the error message exists

    Subprocess calls the mongo command-line tool with --eval and then
    checks the output to see if the error message showed up, such as
    couldn't connect. If the error message exists, then the metric
    will fail.
    """

    eval_string = config.eval_string
    expected_message = config.expected_message
    username = config.username
    password = config.password

    if username and password:
        command = "mongo --username {0} --password {1} --eval '{2}'".format(
            username, password, eval_string)
    else:
        command = "mongo --eval '{0}'".format(eval_string)

    result = subprocess.Popen(
        command, shell=True, stdout=subprocess.PIPE)

    output = result.communicate()[0].decode(
        'utf-8'.strip('\n'))

    if expected_message in output:
        return 1

    return 0
