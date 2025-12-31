#!/bin/bash

# Detectar interfaz activa
INTERFACE=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5}' | head -n1)

[ -z "$INTERFACE" ] && INTERFACE=""

RX_FILE="/sys/class/net/$INTERFACE/statistics/rx_bytes"
TX_FILE="/sys/class/net/$INTERFACE/statistics/tx_bytes"

# Si no existe la interfaz
if [[ ! -f "$RX_FILE" ]]; then
    echo '{"text": "0  0"}'
    exit 0
fi

RX_NOW=$(cat "$RX_FILE")
TX_NOW=$(cat "$TX_FILE")

CACHE="/tmp/.waybar-net"

if [[ -f "$CACHE" ]]; then
    RX_OLD=$(sed -n '1p' "$CACHE")
    TX_OLD=$(sed -n '2p' "$CACHE")
else
    RX_OLD=$RX_NOW
    TX_OLD=$TX_NOW
fi

echo "$RX_NOW" > "$CACHE"
echo "$TX_NOW" >> "$CACHE"

RX_DIFF=$((RX_NOW - RX_OLD))
TX_DIFF=$((TX_NOW - TX_OLD))

human() {
    BYTES=$1

    awk -v B=$BYTES '
    BEGIN {
        if (B >= 1073741824)
            printf "%.1fG", B/1073741824;
        else if (B >= 1048576)
            printf "%.1fM", B/1048576;
        else if (B >= 1024)
            printf "%.1fK", B/1024;
        else
            printf "%dB", B;
    }'
}

DOWN=$(human $RX_DIFF)
UP=$(human $TX_DIFF)

ICON_DOWN=""
ICON_UP=""

echo "{\"text\": \"${DOWN}${ICON_DOWN}  ${UP}${ICON_UP}\"}"
