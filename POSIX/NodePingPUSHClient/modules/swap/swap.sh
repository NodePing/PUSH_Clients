#!/usr/bin/env sh

case $(uname) in
	Linux)
		free -m | awk 'NR==3{printf "%s", $4 }'
		;;
	FreeBSD)
		swapinfo -m | awk 'NR==2{printf "%s", $4 }'
		;;
	OpenBSD)
		swapctl -l | awk 'NR==2{printf "%s", $4 }'
		;;
esac
