# DNS Lookup Module

## Description

This module allows you to run DNS queries on your local machine and see if the
output is the same as you would expect. You can optionally specify the server
to query, what hostname/IP to resolve, the record type you expect, and the
result you expect. This is useful to keep track of what DNS results your
host is getting and can potentially be used as a supplement to check for
DNS poisoning.

## Configuration

You will need to modify the `variables.sh` file in this directory and set your
own values for the metric:

- dns_\__ip: The IP of the DNS server you will query for results
- to\_resolve: The hostname/IP address you will be resolving
- expected\_output: The result you expect from the output
    * If you have multiple values as outputs, separate them with spaces
- record\_type: The record you want to receive (A, AAAA, CNAME, etc.)
