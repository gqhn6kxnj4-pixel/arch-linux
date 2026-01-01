#!/usr/bin/env bash

# =====================================================
# Waybar Updates Module (Arch / CachyOS)
# - Repos oficiales: checkupdates
# - AUR: paru -Qua
# - Output: JSON
# =====================================================

# Contadores
OFFICIAL=0
AUR=0

# Repos oficiales (no requiere root)
if command -v checkupdates >/dev/null 2>&1; then
  OFFICIAL=$(checkupdates 2>/dev/null | wc -l)
fi

# AUR (sin root)
if command -v paru >/dev/null 2>&1; then
  AUR=$(paru -Qua 2>/dev/null | wc -l)
fi

TOTAL=$((OFFICIAL + AUR))

# Sin actualizaciones
if (( TOTAL == 0 )); then
  echo '{"text":"󰏗 0","tooltip":"Sistema actualizado"}'
  exit 0
fi

# Con actualizaciones
echo "{\"text\":\"󰏗 $TOTAL\",\"tooltip\":\"Oficiales: $OFFICIAL | AUR: $AUR\"}"
