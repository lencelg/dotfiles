#!/bin/bash

# ai written scipt

INTERFACE="wlan0"
CACHE_FILE="/tmp/waybar_network_speed_${INTERFACE}.cache"
# ====================

read -r RX_NOW TX_NOW <<< $(awk -v iface="$INTERFACE" '$1 ~ iface":" {gsub(/:/, "", $1); print $2, $10}' /proc/net/dev)

if [[ -z "$RX_NOW" || -z "$TX_NOW" ]]; then
    echo "{\"text\": \"?\", \"tooltip\": \"接口 $INTERFACE 未找到\"}"
    exit 1
fi

if [[ -f "$CACHE_FILE" ]]; then
    source "$CACHE_FILE"   
    TIME_NOW=$(date +%s)
    TIME_DIFF=$((TIME_NOW - TIME_LAST))

    if [[ $TIME_DIFF -gt 0 ]]; then
        RX_SPEED=$(( (RX_NOW - RX_LAST) / TIME_DIFF ))
        TX_SPEED=$(( (TX_NOW - TX_LAST) / TIME_DIFF ))
    else
        RX_SPEED=0
        TX_SPEED=0
    fi
else
    RX_SPEED=0
    TX_SPEED=0
fi

cat > "$CACHE_FILE" <<EOF
RX_LAST=$RX_NOW
TX_LAST=$TX_NOW
TIME_LAST=$(date +%s)
EOF

function format_speed() {
    local val=$1
    if (( val >= 1048576 )); then
        echo "$(echo "scale=1; $val/1024/1024" | bc)M"
    elif (( val >= 1024 )); then
        echo "$(echo "scale=1; $val/1024" | bc)K"
    else
        echo "${val}B"
    fi
}

RX_FMT=$(format_speed $RX_SPEED)
TX_FMT=$(format_speed $TX_SPEED)

echo "{\"text\": \"↓ $RX_FMT ↑ $TX_FMT\", \"tooltip\": \"接口: $INTERFACE\"}"
