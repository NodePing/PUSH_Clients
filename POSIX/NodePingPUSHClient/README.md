# NodePing POSIX PUSH check client

A client for the NodePing PUSH check (https://nodeping.com/push_check.html) for POSIX systems

## Tested distros and systems:

> CentOS 5
> CentOS 6
> CentOS 7
> Debian 9 *
> Devuan 2 *
> Fedora 28
> OpenSUSE LEAP 15
> OpenBSD 6.3
> Raspbian STRETCH
> Ubuntu 14.04
> Ubuntu 16.04
> Ubuntu 18.04

* requires installation of curl

## Configuration

Modify the 'moduleconfig' file to add or remove any metric modules you desire.
Modify the 'NodePingPUSH.sh' file and modify the url on line 3:
Replace CHECK_ID_HERE with your NodePing check id (found in the check drawer  - click on the check name). 
Also replace CHECK_TOKEN_HERE with your NodePing check token (also found in the check drawer)

Example:

```sh
url='https://push.nodeping.com/v1?id=201808131639R5ZBF-9TXFFET4&checktoken=EPRFLBJN-GXU5-4QDG-8BNW-5MAS7QQYTCB4'
```

## Usage

Execute the NodePingPUSH.sh

Example:
```sh
$ ./NodePingPUSH.sh
```

### Logging

To enable logging of the metrics sent and the response received from NodePing on each results push use the -log argument.

Example:
```sh
$ ./NodePingPUSH.sh -log
```

The default logging location is ./NodePingPUSH.log.  Modify the log location in the NodePingPUSH.sh script.

### Debug mode

To run the client and see in the console what metrics would be submitted, run it with the -debug flag. Debug mode does not submit any results to NodePing, it only spits out the metrics JSON.

Example:
```sh
$ ./NodePingPUSH.sh -debug
{"data":{"load":{"1min":0.31,"5min":0.46,"15min":0.36},"memfree":21414,"diskfree":{ "/":0.95}}}
```

## Modules

The NodePing POSIX PUSH client is built to be extended with your own script modules. This allows you to add any metric to the payload and NodePing will track and alert on your check settings for those metrics. 

Create your own script that outputs valid JSON to stdout and then place your unique module name and script path in the moduleconfig file.

For examples, see the modules in the metrics directory.

## Contributions

Found a bug? Built a cool module for xyz? Send it to us!
We'll encourage pull requests for any changes or additions to the clients, new modules, or documentation.

copyright NodePing LLC 2018