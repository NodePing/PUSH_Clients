# diskfree module

## Description

Looks for mountpoints in a system and gathers the free disk space per mountpoint.
This module reports how much disk space is free on scale of `0.0` to `1.0`. So
`0.28` would mean 28% free space **without** accounting for filesystem reserves
(eg: EXT4). For more read: https://github.com/NodePing/PUSH_Clients/issues/37
