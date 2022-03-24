#!/bin/sh

set -e

cc -o lemonconfig -Wall -Wextra -O2 lemonconfig.c

if [ "$1" == "run" ];then
		./lemonconfig
fi
