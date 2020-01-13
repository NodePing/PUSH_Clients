# memavail module

## Description

Gathers the memory available on a system. For Linux this is memory available
that is provided in /proc/meminfo, for FreeBSD it reads free + inactive, and for OpenBSD it reads free + cache.
