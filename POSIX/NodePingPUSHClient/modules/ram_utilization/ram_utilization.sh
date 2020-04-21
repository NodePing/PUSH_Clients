#!/usr/bin/env sh

# Finds amount of memory used by comparing the used memory to the total

echo "$(free -m | grep Mem | awk '{printf ($3 / $2)*100}')"

