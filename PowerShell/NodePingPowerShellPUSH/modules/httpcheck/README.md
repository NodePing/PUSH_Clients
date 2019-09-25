# HTTP Check module

## Description

Get statistics on an HTTP request to a host. Information that is collected to
check against includes:

* http_code: The HTTP code for the connection
* time_total: The total time for the entire operation

## Configuration

In the `httpcheck.json` file:

* Add the URL to the `url` key in the JSON array
* Set the HTTP method (GET, POST, PUT, DELETE)
* Set the content type (default is application/json) if applicable
* Enter the data to submit. If double quotes are in your data, be sure to add escape characters.

To configure the check, go to create your check in NodePing. Add fields like `httpcheck.http_code`, `httpcheck.time_total` and set the min/max times you expect.
