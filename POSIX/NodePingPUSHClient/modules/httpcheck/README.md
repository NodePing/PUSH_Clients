# HTTP Check module

## Description

Get statistics on an HTTP request to a host. Information that is collected to
check against include:

* http_code: The HTTP code
* time_namelookup: The time to resolve the name
* time_connect: The time, in seconds, it took from the start until the TCP connect to the remote
* time_appconnect: The time until the connect/handshake was complete
* time_pretransfer: The time, in seconds, it took from the start until the file transfer was just about to begin
* time_redirect: The time it took for all redirections
* time_starttransfer: Time to first byte
* time_total: The total time for the entire operation


## Configuration

In the `variables.sh` file: 

* Add the URL to the `url` variable (including the http or https prefix).
* Set the HTTP method (GET, POST, PUT, DELETE) in the `http_method` variable
* If there is any JSON data to submit, add it to the `json_data` variable

To configure the check, go to create your check in NodePing. Add fields to look like `httpcheck.http_code`, `httpcheck.time_starttransfer`, `httpcheck.time_total`, etc. and set the min/max times you expect.
