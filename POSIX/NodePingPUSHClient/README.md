# NodePing POSIX PUSH check client

A client for the NodePing PUSH check (<https://nodeping.com/push_check.html>) for POSIX systems

## Tested distros and systems

- CentOS 7
- Rocky/Alma Linux 8 & 9
- Debian 10
- Debian 11/Devuan Chimaera 4.0
- Fedora 36, 37
- FreeBSD 12.x, 13.x
- OpenBSD 7.0+
- OpenSUSE LEAP 15
- Raspbian STRETCH
- Ubuntu 18.04
- Ubuntu 20.04
- Ubuntu 22.04

Requires installation of curl

## Configuration

* Modify the 'moduleconfig' file and put the module names you want to run. You can add or remove any metric modules you desire.
* On line 3 of NodePingPUSH.sh, add your Check ID to the `CHECK_ID` variable (found in the check drawer - click on the name of the check).
* On line 4 of NodePingPUSH.sh, add your Checktoken to the `CHECK_TOKEN` variable (also found in the check drawer).

Example:

```sh
CHECK_ID="201808131639R5ZBF-9TXFFET4"
CHECK_TOKEN="EPRFLBJN-GXU5-4QDG-8BNW-5MAS7QQYTCB4"
```

### Optional Configuration

* Modify the 'NodePingPUSH.sh' file and edit the logfilepath on line 6 to be the absolute path that you want the logfile at. Default is the current directory of `NodePingPUSH.sh`.
* Modify the 'NodePingPUSH.sh' file and edit the retries on line 11 to set the number of times you want the client to retry connecting if the client is unable to connect the first time.
* Modify the 'NodePingPUSH.sh' file and edit the timeout on line 12 to determine how many seconds you want to timeout the connection if the server cannot be reached.

## Usage

Execute the NodePingPUSH.sh

Example:

```sh
./NodePingPUSH.sh
```

### Logging

To enable logging of the metrics sent and the response received from NodePing on each results push use the -log argument.

Example:

```sh
./NodePingPUSH.sh -log
```

The default logging location is ./NodePingPUSH.log.  Modify the log location in the NodePingPUSH.sh script.

### Debug mode

To run the client and see in the console what metrics would be submitted, run it with the -debug flag. Debug mode does not submit any results to NodePing, it only spits out the metrics JSON.

Example:

```sh
$ ./NodePingPUSH.sh -debug
{"data":{"load":{"1min":0.31,"5min":0.46,"15min":0.36},"memfree":21414,"diskfree":{ "/":0.95}}}
```

The default metrics sent are:

- Load: 1 minute, 5 minute, and 15 minute system load
This is tacked by the path/name field "load.1min", "load.5min", and "load.15min".

- Memory free space: MB RAM free
This is tracked by the path/name field "memfree"

- Disk free space: percentage of each partition that is free space by mount point
This is tracked by the path/name field "diskfree.yourmountpoint" - example: "diskfree./".

## Modules

The NodePing POSIX PUSH client is built to be extended with your own script modules. This allows you to add any metric to the payload and NodePing will track and alert on your check settings for those metrics.

Create your own script that outputs valid JSON to stdout and then place your unique module name and script path in the moduleconfig file.

For examples, see the modules in the metrics directory.

## Contributions

Found a bug? Built a cool module for xyz? Send it to us!
We encourage pull requests for any changes or additions to the clients, new modules, or documentation.

copyright NodePing LLC 2022
