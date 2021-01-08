#!/bin/bash

if [ -z "$@" ]; then
    echo -en "Shutdown\0icon\x1fsystem-shutdown\n"
    echo -en "Reboot\0icon\x1fsystem-restart\n"
    echo -en "Hibernate\0icon\x1fsystem-hibernate\n"
    echo -en "Suspend\0icon\x1fsystem-suspend\n"
else
    if [ "$1" = "Shutdown" ]; then
        poweroff
    elif [ "$1" = "Reboot" ]; then
        reboot
    elif [ "$1" = "Suspend" ]; then
        sudo pm-suspend
    elif [ "$1" = "Hibernate" ]; then
        sudo pm-hibernate
    fi
fi