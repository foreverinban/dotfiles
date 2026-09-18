#!/usr/bin/env bash
set -euo pipefail

echo "== Установка pacman-пакетов =="
sudo pacman -S --needed - < packages.txt

echo "== Установка AUR-пакетов (нужен yay) =="
yay -S --needed - < aur-packages.txt

echo "== Применение дотфайлов через chezmoi =="
chezmoi apply

echo "Готово. Перелогинься/перезагрузись для применения автостарта Hyprland."
