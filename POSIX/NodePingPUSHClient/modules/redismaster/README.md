# redismaster module

## Description

Checks with the sentinel to discover what the IP is of the master it is monitoring.
Checks if the stored IP is the same of the current Redis Master. Returns 1 if the
addresses match for Pass or 0 for Fail.

## Configuration

* Add the appropriate data to the redismaster.txt file
* Make sure redis-sentinel is installed and can communicate with a sentinel that is watching the Redis master
