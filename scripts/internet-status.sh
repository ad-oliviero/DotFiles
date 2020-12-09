#!/bin/bash

if curl -s --head  --request GET www.google.com | grep "200 OK" > /dev/null ; then
    echo " "
else
    echo " "
    notify-send "Not connected to Internet"
fi

