# NodePing PUSH check clients

This is a collection of clients to push heartbeats and metrics to **NodePing**.

Linux, FreeBSD, Raspberry Pi, etc will find the POSIX and Python2/3 clients useful.
Windows users would do well with the PowerShell or Python2/3 clients.

## NodePing PUSH checks

Create a PUSH check for things like monitoring your servers that are behind firewalls, tracking CPU load, or getting alerts before you run out of disk space.

Please see the full documentation for the PUSH check at <https://nodeping.com/push_check.html>

If you don't yet have a **NodePing** account, you can sign up for a free 15-day trial at <https://nodeping.com/>

## Heartbeats

Use simple heartbeats to let NodePing know your server is up and functioning. You can configure your NodePing PUSH check to alert you if your server stops sending in results.

## Metrics

Your PUSH client can send in metrics, like system load and disk free space, and NodePing will track and send alerts if your metrics are outside your configured normal range.

## Modules

NodePing PUSH checks are built to be extended with your own script modules. This allows you to add any metric to the payload and NodePing will track and alert on your check settings for those metrics. Want to keep track of slow MySQL queries or pageviews, write your script to gather the metrics as a module for one of our clients and drop it in place.  See the individual clients for instructions on how to add your own modules.

## Multiple Check IDs

If you wish to push metrics with multiple check IDs to, for example, keep them separate or if you want to run checks at different intervals (like one set at 1 minute and another at 30 minutes), you can accomplish this by creating a duplicated folder. It is recommended to have a `push_agents` directory and within that directory have a copy of the check client separated based on your needs. For example, your file structure could look like this:

`/home/user/push_agents/1minute_checks`
`/home/user/push_agents/30minute_checks`

## Contributions

Found a bug? Write a cool module? Got a client written in BASIC? Send it to us!
We encourage pull requests for clients, modules, documentation, all of it. We appreciate your contributions.

copyright NodePing LLC 2019