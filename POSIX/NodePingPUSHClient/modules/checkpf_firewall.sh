#!/usr/bin/env sh

# Checks the count of pf rules and alerts if the number of rules has changed.
# User running this needs super user privileges

# Tested with: OpenBSD, FreeBSD

rulecount=$(pfctl -sr | wc -l | xargs)

echo $rulecount