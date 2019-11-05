# smartctl module

## Description

Get a health check via smartmontools to see if drives are passing the SMART test.

## Configuration

Place the names of the disks you want to check in the `smartdrives.sh` file in the `drives` variable. If you have more than one, separate the names with a space. These are drives names that smartmontools would expect like `/dev/sda`, `/dev/nvme1n1`, `/dev/ada0`, etc. In Linux you can verify drive names using `fdisk -l` and on FreeBSD with `camcontrol devlist`.
