#!/usr/bin/env sh

# Checks the count of iptables rules and alerts if the number of rules has changed.
# User running this needs super user privileges

ipv4rules=$(/sbin/iptables -n --list --line-numbers | sed '/^num\|^$\|^Chain/d' | wc -l)
ipv6rules=$(/sbin/ip6tables -n --list --line-numbers | sed '/^num\|^$\|^Chain/d' | wc -l)

printf "{\"ipv4\":%s\"ipv6\":%s}" $ipv4rules, $ipv6rules
