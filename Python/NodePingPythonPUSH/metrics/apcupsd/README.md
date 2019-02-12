# apcupsd module

## Description:

Checks the status of your APC battery that is configured via apcupsd.
This check looks at the status of the `apcaccess status` command and
checks if the status is online.

## Configuration

Be sure to have the apcupsd package installed and daemon running on your system
