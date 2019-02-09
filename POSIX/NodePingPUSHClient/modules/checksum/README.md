# checksum module

## Description

This module will alert you if a file checksum has
changed for the specified files. If no hash is provided, defaults to SHA256
Each file must have the pattern of `/path/to/file checksum`
Create a "checksum.txt" file in the same directory as this module and
enter the filename and checksum on a new line each.
Set the permissions to 0400 when finished adding data.

Supported checksum types:
	* sha1
	* sha256
	* sha512
	* md5sum

## Configuration

* Add the supported checksum type to the checksum_type.txt file
* In the checksums.txt file, add the file name and checksum according to the template
