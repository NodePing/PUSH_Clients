# Net Utilization

## Description

Track your bandwidth usage on each specified interfaces, as a percentage of some
specified number (such as the amount allocated on a connection) as well as bytes
sent and received. This module reports bytes transferred and received as
well as the percentage of the configured values allowed.

### How it Works

The operating system has `tx_bytes` and `rx_bytes` values that are tracked
once the operating system boots. To track the amount of traffic in a given
period of time, we need the value reported by the OS at the beginning of the
period, and then subtract that from the amount reported by the OS at the end of
the period. This module can track that between intervals that the script is run,
or you can instead report on a snapshot of X seconds of traffic. The module then
reports the bytes sent and received, as well as the percentage of the expected
value you set in the module configuration. 

## Usage

There are two modes:

## Usage

There are two modes of how/when this data is collected:

1. Traffic reported between each PUSH 
2. Snapshot of time

### Between Each PUSH

Collect the bandwidth that has been used in between each PUSH interval.
For example, if a 1 minute PUSH interval is specified, the script will gather
the amount of bytes rx/tx and compare it to the amount of bytes that were rx/tx
at the last PUSH interval. This method stores the `tx_bytes` (tx) and
`rx_bytes` (rx) in the `last_values.txt` file each time the module is run. 

For eample, if the current bytes received since boot is 1814312146 bytes and
the previous value stored in `last_values.txt` is 1641184862.
The difference will be taken between the two and then averaged out to find the
total mbps over that window. 

This mode is best used if you have multiple interfaces for this metric and if
you want values calculated at intervals of a minute or longer. If you have a
system with multiple interfaces with a 5 second window of collecting data it
would take 5 seconds to collect the bandwidth used for each interface. In the
case of three interfaces, it could take 15 seconds to run. 

#### Configuration

If you want this behavior, set `each_push` to `"true"` in the
`variables.sh` file. Then set the `sleep_interval`. This is the amount of time in
seconds between each time the script runs. So a 1 minute interval is 60 seconds, 3
minutes in 180 seconds and so on.

### Snapshot of Time

This option doesn't take the previous value out of the `last_values.txt` file
but rather at runtime will collect the rx/tx bytes, wait for the specified
amount of time, and then collect the values again. For example, if you set
`sleep_interval` to 5, the script will collect the rx/tx bytes, sleep 5 seconds,
and then collect the rx/tx bytes again to calculate the values for each
interface specified. These values will not be stored in the `last_values.txt` file.

This method will not capture all the traffic sent and received, but rather a
snapshot of what the traffic amounts look like. If you take a 5 second snapshot
of a 60 second run interval, you are only sampling 1/12th of the traffic.

This is useful for handling a couple interfaces and collecting metrics at short
intervals.

#### Configuration

For this behavior, set `each_push` to `false` and set `sleep_interval` to the
desired amount of seconds you want to collect bandwitdth metrics.

## General configuration

All configurations will go in the `variables.sh` file.

The other variables available to set are:

* `interfaces` - the names of the interface(s) you want to monitor
* `expected_net_utilization_rx` - the maximum bandwidth expected for downloads
  (in mbps)
* `expected_net_utilization_tx` - the maximum bandwidth expected for uploads (in
  mbps)
  
## Optional Configuration
  
If you plan on using the `Each Push` method, you can optionally prime the
`last_values.txt` file with current values. If you don't, on first run it will
run for 5 seconds and calculate the speed and then resume from there. The
`last_values.txt` file already has some sample data in it for you to see how it
has to be arranged.

To get these values, you can run this command to get the current "rx" and "tx" values:

``` sh
cat /sys/class/net/eth0/statistics/rx_bytes
cat /sys/class/net/eth0/statistics/tx_bytes
```

And insert those values into your `last_values.txt` according to the sample.


## Check Configuration

When configuring the checks, the `min` and `max` values are the minimum expected
percentage of bandwidth used and the maximum expected percentage of bandwidth
used. If you wish to be alerted when an interface is using 80% of its bandwidth,
you would set the `max` value to 80. The `name` field is configured as such:

If the interface name is "Ethernet 7", and you want the rx_percent, set the name
to `net_utilization.eth0.rx_percent`.
