# NodePing PowerShell PUSH check client

A PowerShell client for the NodePing PUSH check (<https://nodeping.com/push_check.html>).
This has been tested on Windows server 2012 and 2016 versions and sends heartbeat and metrics to NodePing for tracking and monitoring.

## Configuration

Modify the 'NodePingPUSH.ps1' file and set the check id and check token on lines 4 and 5:
Replace "Your Check ID here" with your NodePing check id (found in the check drawer  - click on the check name).
Also replace "Your Check Token here" with your NodePing check token (also found in the check drawer)

Example:

```sh
Param(
        [string]$url = "https://push.nodeping.com/v1",
        [string]$logfile = "NodePingPUSH.log",
        [string]$checkid = "201808131639R5ZBF-9TXFFET4",
        [string]$checktoken = "EPRFLBJN-GXU5-4QDG-8BNW-5MAS7QQYTCB4",
        [switch]$debug = $True,
        [switch]$log = $True
)
```

You'll also need to adjust the paths for the modules in the moduleconfig.json file.

## Usage

Have PowerShell call NodePingPUSH.ps1

Example:

```sh
powershell.exe C:\\Users\\You\\Desktop\\NodePingPowerShellPUSH\\NodePingPUSH.ps1
```

### Logging

To enable logging of the metrics being sent and the response received from NodePing on each result, pass in the -log argument to the script command.

Example:

```sh
powershell.exe C:\\Users\\You\\Desktop\\NodePingPowerShellPUSH\\NodePingPUSH.ps1 -log
```

The default logging location is NodePingPUSH.log.  Modify the log location in the NodePingPUSH.ps1 file - it's the logfile parameter on line 3.

### Debug mode

To run the client and see in the console what metrics would be submitted, run it with the -debug argument. Debug mode does not submit any results to NodePing, it only spits out the metrics JSON. It's a easy way to test the output of your own modules.

Example:

```sh
powershell.exe C:\\Users\\You\\Desktop\\NodePingPowerShellPUSH\\NodePingPUSH.ps1 -debug
{"id":"Your Check ID here","checktoken":"Your Check Token here","data":{"memfree":12403,"cpuload":0.46,"diskfree":{ "C":0.05,"D":1}}}
```

The default metrics sent are:

* CPU load: percentage of load on the CPU
This is tacked by the path/name field "cpuload".

* Memory free space: MB RAM free
This is tracked by the path/name field "memfree"

* Disk free space: percentage of each partition that is free space by disk letter.
This is tracked by the path/name field "diskfree.yourdiskletter" - example: "diskfree.C".

## Modules

The NodePing PowerShell PUSH client is built to be extended with your own modules. This allows you to add any metric to the payload and NodePing will track and alert on your check settings for those metrics.

Create your own module and we suggest you save it in the modules directory under a unique name in its own subdirectory.  Then set it's configuration in the moduleconfig.json file.

The script should output valid JSON to stdout with numeric values (integers or floats).

Please see the examples of other modules in the modules directory and their lines in the moduleconfig.json file.

## Contributions

Found a bug? Built a cool module for xyz? Send it to us!
We'll encourage pull requests for any changes or additions to the clients, new modules, or documentation.

copyright NodePing LLC 2019