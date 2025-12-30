#!/bin/bash

WALLDIR="/home/sergio-arch/wallpapers"

# Elegir un wallpaper al azar
WALL=$(find "$WALLDIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n1)

# Esperar a que hyprpaper esté listo
sleep 1

# Cargar y aplicar
hyprctl hyprpaper preload "$WALL"
hyprctl hyprpaper wallpaper ",$WALL"
hyprctl hyprpaper unload unused
