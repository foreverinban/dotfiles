#!/usr/bin/env bash
# rice-bootstrap.sh — одноразовая донастройка системы под rice (запускать из ~/.local/share/chezmoi).
# Идемпотентен: можно гонять повторно. Root нужен только для пакетов и SDDM.
set -euo pipefail
cd "$(dirname "$0")"
say() { printf '\n\033[1;34m== %s\033[0m\n' "$*"; }

# ── Этап 1: палитра / GTK / Qt ─────────────────────────────────────────────
PKGS_STAGE1=(python-pywal16 imagemagick jq openbsd-netcat qt5ct qt6ct adw-gtk-theme ttf-jetbrains-mono-nerd)
