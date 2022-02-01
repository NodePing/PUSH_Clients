# jails module

## Description

Collects jails with `jls` and submits them with a status of 1 for passing.
`jls` only lists running jails, so any down jail won't be submitted and
thus fail the check.
