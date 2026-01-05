#!/usr/bin/env bash

set -e

echo "========================================"
echo " Instalador de Arch Linux personalizado"
echo "========================================"
echo

# 1. Verificar que estamos en Arch
if ! command -v pacman >/dev/null; then
  echo "❌ Esto no es Arch Linux"
  exit 1
fi

# 2. Actualizar sistema
echo "🔄 Actualizando sistema base..."
sudo pacman -Syu --noconfirm

# 3. Instalar paquetes definidos por el usuario
if [[ -f pkglist.txt ]]; then
  echo "📦 Instalando paquetes desde pkglist.txt..."
  sudo pacman -S --needed --noconfirm - < pkglist.txt
else
  echo "⚠️ pkglist.txt no encontrado, saltando paquetes"
fi

# 4. Copiar dotfiles
echo "📁 Instalando dotfiles..."
cp -r dotfiles/.* ~/

echo "✅ Instalación base completada"
echo "➡️ Reinicia sesión para aplicar cambios"
