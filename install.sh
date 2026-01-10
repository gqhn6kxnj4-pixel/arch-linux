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
echo "🔗 Creando enlaces simbólicos..."

for file in dotfiles/.zshrc; do
  target="$HOME/$(basename "$file")"

  if [[ -e "$target" || -L "$target" ]]; then
    echo "⚠️ $target ya existe, se omite"
  else
    ln -s "$(pwd)/$file" "$target"
    echo "✔ Enlace creado: $target"
  fi
done

# Enlaces para ~/.config
mkdir -p ~/.config
for dir in dotfiles/.config/*; do
  name=$(basename "$dir")
  target="$HOME/.config/$name"

  if [[ -e "$target" || -L "$target" ]]; then
    echo "⚠️ ~/.config/$name ya existe, se omite"
  else
    ln -s "$(pwd)/$dir" "$target"
    echo "✔ Enlace creado: ~/.config/$name"
  fi
done

# Enlaces para ~/.local/bin
mkdir -p ~/.local
if [[ ! -e ~/.local/bin ]]; then
  ln -s "$(pwd)/dotfiles/.local/bin" ~/.local/bin
  echo "✔ Enlace creado: ~/.local/bin"
else
  echo "⚠️ ~/.local/bin ya existe, se omite"
fi

echo "✅ Instalación base completada"
echo "➡️ Reinicia sesión para aplicar cambios"
