# redismaster module

## Description

Checks with the sentinel to discover what the IP is of the master it is monitoring
Checks if the stored IP is the same of the current Redis Master. Returns 1 if the
addresses match for Pass or 0 for Fail.

## Configuration

* Edit the config.py file
  * Set REDIS_MASTER to the name of the master server
  * Set REDIS_MASTER_IP To the expected IP address
  * Set the SENTINEL_IP to the address of the Redis Sentinel you will be querying
  * Set the PORT to the port to query on the Redis Sentinel
