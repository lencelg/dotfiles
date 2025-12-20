#!/bin/bash

INFO=$(iw dev wlan0 link)
ROUTER=$(ip r | grep default | awk '{print $3}')

if [[ "$INFO" == "Not connected." ]]; then
    echo " 󰖪 Disconnected"
else
    ESSID=$(echo "$INFO" | grep SSID | awk '{print $2}')
    SIGNAL=$(echo "$INFO" | grep signal | awk '{print $2}')
    echo "{\"text\": \"󰈀 ${ESSID} 󱂇 ${ROUTER}\"}"
fi
