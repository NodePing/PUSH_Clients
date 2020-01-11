# memavail module

## Description

Gathers the memory available on a system. For Linux this is memory available
that is provided in /proc/meminfo, for FreeBSD 11 it is free + inactive +
buffer, for FreeBSD 12 it is free + inactive, and for OpenBSD it is free + cache.
