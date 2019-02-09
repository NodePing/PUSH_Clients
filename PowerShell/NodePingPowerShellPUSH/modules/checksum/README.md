# checksum module

## Description

Accepts a hashing algorithm and your choice of files and their known checksum.
This module then checks the current checksum of that file and with the stored
checksum and returns a 1 if the checksums match, or a 0 for fail if they dont.

## Configuration

* Modify the `checksum.json` file
    * For each file, set the filename, its expected hash, and hashing algorithm

**Note** - The hashing algorithm has to be supported by PowerShell's `Get-FileHash`.
* SHA1
* SHA256
* SHA384
* SHA512
* MD5
