# fileage module

## Description

This module will alert you if a file is older than you expect it to be.
For example, if you expect a file to change once every 24 hours, this module
will send a fail if the file's mtime goes beyond that 24 hours you have
specified. You can do the inverse of this by modifying the check in the
check drawer on nodeping.com and setting the expected value to 0.

## Configuration

Each line represents a file to check

#filename     Days hours  minutes
/path/to/file 24   10     5

Set each file on its own line and have a space between each variable.
