# checksum module

## Description

Accepts a hashing algorithm and your choice of files and their known checksum.
This module then checks the current checksum of that file and with the stored
checksum and returns a 1 if the checksums match, or a 0 for fail if they dont.

## Configuration

* Modify the `files` dictionary in the config.py file
* Add values where the key is the expected checksum and the value is the full path to the file
* Set the hash_algorithm variable to a hashing algorithm
  * md5
  * sha1
  * sha224
  * sha256
  * sha384
  * sha512
