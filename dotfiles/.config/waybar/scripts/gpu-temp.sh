#!/usr/bin/env bash

# =====================================================
# GPU Temperature for Waybar (NVIDIA first)
# - Output: text only
# - Icon: 
# - Interval recomendado: 2s
# - Fallbacks: sensors / hwmon
# - Sin GPU o error: "GPU OFF"
# =====================================================

ICON=""

# === 1. NVIDIA (nvidia-smi) ===
if command -v nvidia-smi >/dev/null 2>&1; then
  TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)

  if [[ "$TEMP" =~ ^[0-9]+$ ]]; then
    echo "{\"text\":\"$ICON ${TEMP}°C\"}"
    exit 0
  fi
fi

# === 2. lm-sensors ===
if command -v sensors >/dev/null 2>&1; then
  TEMP=$(sensors 2>/dev/null | awk '
    /GPU|edge|junction/ && /\+/ {
      gsub(/[^0-9.]/,"",$2)
      print int($2)
      exit
    }
  ')

  if [[ "$TEMP" =~ ^[0-9]+$ ]]; then
    echo "{\"text\":\"$ICON ${TEMP}°C\"}"
    exit 0
  fi
fi

# === 3. /sys/class/hwmon fallback ===
for hwmon in /sys/class/hwmon/hwmon*/temp*_input; do
  [[ -r "$hwmon" ]] || continue
  TEMP_RAW=$(cat "$hwmon" 2>/dev/null)

  if [[ "$TEMP_RAW" =~ ^[0-9]+$ ]] && (( TEMP_RAW > 10000 )); then
    TEMP=$((TEMP_RAW / 1000))
    echo "{\"text\":\"$ICON ${TEMP}°C\"}"
    exit 0
  fi
done

# === 4. Sin GPU o error ===
echo '{"text":"GPU OFF"}'
