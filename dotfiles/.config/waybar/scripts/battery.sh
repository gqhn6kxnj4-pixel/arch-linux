#!/bin/bash

BAT="/sys/class/power_supply/BAT1"
AC="/sys/class/power_supply/ACAD/online"

# Si no existen los archivos, abortamos con texto vacío
if [ ! -f "$BAT/capacity" ] || [ ! -f "$BAT/status" ]; then
    echo "{\"text\": \" --%\", \"class\": \"battery\"}"
    exit 0
fi

capacity=$(cat "$BAT/capacity")
status=$(cat "$BAT/status")
ac_online=$(cat "$AC" 2>/dev/null)

# Selección de icono estilo macOS
if [[ "$status" == "Charging" ]] || [[ "$ac_online" == "1" ]]; then
    icon=""
else
    if   [ "$capacity" -ge 95 ]; then icon=""
    elif [ "$capacity" -ge 75 ]; then icon=""
    elif [ "$capacity" -ge 50 ]; then icon=""
    elif [ "$capacity" -ge 25 ]; then icon=""
    else icon=""
    fi
fi

text="$icon  ${capacity}%"

echo "{\"text\": \"$text\", \"class\": \"battery\"}"
