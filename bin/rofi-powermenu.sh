#!/bin/bash

if [ -z "$@" ]; then
    echo -en "Shutdown\0icon\x1fsystem-shutdown\n"
    echo -en "Reboot\0icon\x1fsystem-restart\n"
#	echo -en "FReboot\0icon\x1fsystem-restart\n"
    echo -en "Suspend\0icon\x1fsystem-suspend\n"
    echo -en "Hibernate\0icon\x1fsystem-hibernate\n"
else
    if [ "$1" = "Shutdown" ]; then
        poweroff
    elif [ "$1" = "Reboot" ]; then
        reboot
#    elif [ "$1" = "FReboot" ]; then
#        ~/.config/scripts/fast-reboot.sh
    elif [ "$1" = "Suspend" ]; then
        swaylock -C ~/.config/swaylock/config || ~/.config/scripts/lock & systemctl suspend
    elif [ "$1" = "Hibernate" ]; then
        swaylock -C ~/.config/swaylock/config || ~/.config/scripts/lock & systemctl hibernate
    fi
fi
