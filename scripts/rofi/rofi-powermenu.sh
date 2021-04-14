#!/bin/bash

if [ -z "$@" ]; then
    echo -en "Shutdown\0icon\x1fsystem-shutdown\n"
    echo -en "Reboot\0icon\x1fsystem-restart\n"
    echo -en "FReboot\0icon\x1fsystem-restart\n"
    echo -en "Suspend\0icon\x1fsystem-suspend\n"
else
    if [ "$1" = "Shutdown" ]; then
        sudo poweroff
    elif [ "$1" = "Reboot" ]; then
        sudo reboot
    elif [ "$1" = "FReboot" ]; then
        sudo ~/.config/scripts/fast-reboot.sh
    elif [ "$1" = "Suspend" ]; then
        sudo pm-suspend
    fi
fi
