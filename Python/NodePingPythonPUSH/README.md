# NodePing Python PUSH check client

A python client for the NodePing PUSH check (https://nodeping.com/push_check.html).
This has been tested on python 2.7.x and popular Linux distros, FreeBSD, OpenBSD, and Windows server versions. Windows and FreeBSD versions require the additional install of psutil, which is easily installed via pip.

## Configuration

Modify the 'config.ini' file and set the check id and check token on lines 9 and 10:
Replace YourCheckID with your NodePing check id (found in the check drawer  - click on the check name). 
Also replace YourCheckToken with your NodePing check token (also found in the check drawer)

Example:

```sh
# The base URL (without the query string) to POST the metrics to.
url = push.nodeping.com/v1
id = 201808131639R5ZBF-9TXFFET4
checktoken = EPRFLBJN-GXU5-4QDG-8BNW-5MAS7QQYTCB4
```

## Usage

Execute the NodePingPythonPUSH.py

Example:
```sh
$ ./NodePingPythonPUSH.py
```

### Logging

To enable logging of the metrics sent and the response received from NodePing on each result, modify the config.ini file.

Set the log config to yes

Example:
```sh
log = yes
```

The default logging location is ./push.log.  Modify the log location in the config.ini file.

### Debug mode

To run the client and see what metrics would be submitted, run it with the --showdata argument. Debug mode does not submit any results to NodePing, it only spits out the metrics JSON. It's a easy way to test the output of your own modules.

Example:
```sh
$ ./NodePingPythonPUSH.py --showdata
{"data": {"diskfree": {"/": 0.95, "/opt": 1.0}, "load": {"1min": 0.3, "5min": 0.43, "15min": 0.52}, "memfree": 3053}}
```

## Modules

The NodePing Python PUSH client is built to be extended with your own modules. This allows you to add any metric to the payload and NodePing will track and alert on your check settings for those metrics. 

Drop your Python file with the name of the subkey of data you'd like your metrics to fall under in the metrics/ folder.

The file needs a main function which receives two arguments: system and logger. system will correspond to one of the three strings 'FreeBSD', 'Linux', or 'Windows', and the logger is a standard Python logger configured to output to the error logfile specified in config.ini.

The logger should be used to record non-fatal errors and warning with the logger.warn and logger.error methods. For fatal module errors, don't fret about catching the exceptions. Those will be handled from the higher-up logic.

The main function should always return the output of calling the _utils.report function on the result(s) of the metrics, which will need to be either a single value or a dictionary.

You'll then need to add a line to the config.ini with the unique name of your module and the value 'yes' to enable it.

Example:
```sh
[modules]
mymodulename = yes
```

The _utils file also contains a couple other helper functions, which you may find useful in standardizing the reporting of percentages and other decimal values.

Please see the examples of other modules in the metrics directory and their lines in the config.ini file.

## Contributions

Found a bug? Built a cool module for xyz? Send it to us!
We'll encourage pull requests for any changes or additions to the clients, new modules, or documentation.

copyright NodePing LLC 2018