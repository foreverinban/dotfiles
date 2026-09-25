#!/usr/bin/env bash
# rice-bootstrap.sh — одноразовая донастройка под rice. Запуск: ~/.local/share/chezmoi/rice-bootstrap.sh
# Идемпотентен. sudo нужен только для пакетов и SDDM (шаги 1 и 5).
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"
say() { printf '\n\033[1;34m== %s\033[0m\n' "$*"; }
export PATH="$HOME/.local/bin:$PATH"

# ── 1. пакеты (repo + AUR через yay) ───────────────────────────────────────
RICE_PKGS=(
  # этап 1 — палитра, GTK/Qt
  python-pywal16 imagemagick jq openbsd-netcat qt5ct qt6ct ttf-jetbrains-mono-nerd
  # этап 2 — блокировка и логин
  hyprlock sddm-astronaut-theme qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
  # этапы 3–4 — waybar/терминал
  curl openssh zellij starship bat eza fastfetch
  # этап 6–7 — уведомления, иконки, курсор
  swaync libnotify papirus-icon-theme papirus-folders python-pipx nodejs npm
  # этап 11–12 — скриншоты, буфер, power menu
  grimblast-git swappy cliphist wl-clipboard wlogout btop
  # Fn-ряд ThinkPad
  brightnessctl playerctl bluez-utils
)
say "Пакеты"
# ставим только то, чего нет (pacman -T учитывает provides: adw-gtk-theme-git и т.п.)
mapfile -t MISSING < <(pacman -T "${RICE_PKGS[@]}" || true)
if [ ${#MISSING[@]} -gt 0 ]; then yay -S --needed "${MISSING[@]}"; else echo "  всё уже стоит"; fi

# ── 2. дотфайлы ────────────────────────────────────────────────────────────
say "chezmoi diff (просмотри) → apply"
chezmoi diff | ${PAGER:-less -R} || true
read -rp "Применить? [y/N] " a; [[ "$a" == [yY] ]] && chezmoi apply -v

# ── 3. тема: палитра + шаблоны ─────────────────────────────────────────────
say "Первая раскладка палитры"
rice-apply --next || true

# ── 4. GTK / иконки / курсор / папки ───────────────────────────────────────
say "GTK, Papirus, курсор, иконки папок"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Rice-Cursor'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 10'
command -v papirus-folders >/dev/null && papirus-folders -C bluegrey --theme Papirus-Dark || true
command -v ctgen >/dev/null || pipx install clickgen || true
rice-cursor-build || true
rice-folder-icons || true
xdg-user-dirs-update || true
bat cache --build >/dev/null 2>&1 || true

# ── 5. SDDM (root) ─────────────────────────────────────────────────────────
say "SDDM: sddm-astronaut-theme + палитра rice"
THEME=/usr/share/sddm/themes/sddm-astronaut-theme
if [ -d "$THEME" ]; then
    sudo install -d -o "$USER" -g "$(id -gn)" -m 755 /var/lib/rice-sddm
    sudo ln -sfn /var/lib/rice-sddm/background.jpg     "$THEME/Backgrounds/rice.jpg"
    sudo ln -sfn /var/lib/rice-sddm/astronaut.conf.user "$THEME/Themes/astronaut.conf.user"
    sudo install -d -m 755 /etc/sddm.conf.d
    printf '[Theme]\nCurrent=sddm-astronaut-theme\n' | sudo tee /etc/sddm.conf.d/99-rice.conf >/dev/null
    rice-apply --reload || true   # положит обои + цвета в /var/lib/rice-sddm
else
    echo "  $THEME не найден — пропускаю"
fi

# ── 6. DND по расписанию ───────────────────────────────────────────────────
say "systemd user timers: DND"
systemctl --user daemon-reload
systemctl --user enable --now rice-dnd-on.timer rice-dnd-off.timer

say "Готово. Перелогинься: автостарт (cliphist, wallpaper-watcher) и env (XCURSOR_THEME, QT_QPA_PLATFORMTHEME) применяются только после релогина."
