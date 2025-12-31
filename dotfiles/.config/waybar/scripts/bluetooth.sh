#!/bin/bash

if ! systemctl is-active --quiet bluetooth; then
  echo '{"text":"󰂲 OFF","class":"off"}'
  exit 0
fi

status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [[ "$status" == "yes" ]]; then
  connected=$(bluetoothctl info 2>/dev/null | grep "Connected: yes")
  if [[ -n "$connected" ]]; then
    echo '{"text":"󰂯 ON","class":"connected"}'
  else
    echo '{"text":"󰂯 ON","class":"on"}'
  fi
else
  echo '{"text":"󰂲 OFF","class":"off"}'
fi
