#!/usr/bin/env bash

# =====================================================
# Active application name for Waybar (Hyprland)
# - Output: text only
# - Source: hyprctl
# - Fallback: Desktop
# =====================================================

# Obtener clase de la ventana activa
APP=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class')

# Normalizar salida
if [[ -z "$APP" || "$APP" == "null" ]]; then
  echo '{"text":"Desktop"}'
  exit 0
fi

# Capitalizar primera letra (Firefox, Kitty, Brave)
APP_FMT="$(tr '[:upper:]' '[:lower:]' <<< "$APP")"
APP_FMT="$(sed 's/^./\U&/' <<< "$APP_FMT")"

echo "{\"text\":\"$APP_FMT\"}"
