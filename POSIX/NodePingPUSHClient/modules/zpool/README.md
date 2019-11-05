# zpool module

## Description

Checks the list of zpool names in `pools.sh` and checks their state. If ONLINE, the check will pass for that zpool. If the state is not ONLINE, then the check will fail.

## Configuration

Place the names of the zpools you want to check in the `pools.sh` file in the `pools` variable. If you have more than one, separate the names with a space.
