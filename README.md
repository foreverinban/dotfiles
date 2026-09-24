# dotfiles (chezmoi) — Arch + Hyprland (Lua) + pywal16

## Rice: одна палитра на всё
```
обои из пула ─► wal ─► ~/.cache/wal/*  (kitty, waybar-цвета, btop, nvim/pywal.nvim)
                    └► rice-render ─► ~/.cache/rice/*  (единый accent + OPACITY из ~/.config/rice/rice.conf)
                                       colors.lua → hyprland.lua (рамка), nvim (lualine/ibl/nvim-tree)
                                       rice.css → waybar · wofi.css · swaync.css · wlogout.css
                                       gtk.css → GTK3/4 (Nautilus) · qt-colors.conf → qt5ct/qt6ct
                                       hyprlock-colors.conf · sddm.conf.user · kitty.conf · starship.toml
                                       fastfetch.jsonc + logo.txt (ASCII из текущих обоев)
```
- `rice-apply --next | --random | --reload | <img>` — сменить обои и перекрасить всё (SUPER+SHIFT+W)
- ротация: `wallpaper-watcher.sh` (автостарт) — при логине и раз в `ROTATE_INTERVAL`
- пул: `~/Pictures/Wallpapers/pool/` (симлинки); accent: `ACCENT_SLOT` в `rice.conf`
- шаблоны: `~/.config/rice/templates/*`, плейсхолдеры `{{accent}}`, `{{accent_x}}`, `{{accent_rgb}}`, `{{accent_ansi}}`

Первичная установка: `./rice-bootstrap.sh` (пакеты, apply, gsettings, курсор, SDDM, DND-таймеры).

## Хоткеи (добавленные)
| клавиши | действие |
|---|---|
| SUPER+L | hyprlock |
| SUPER+Escape | wlogout |
| SUPER+N / SUPER+SHIFT+N | центр уведомлений / DND |
| Print, SUPER+SHIFT+H | область → swappy (первый инструмент — blur) |
| SHIFT+Print | область → буфер + ~/photo/screenshots |
| SUPER+V | история буфера (cliphist + wofi, превью картинок) |
| SUPER+SHIFT+B | btop в плавающем kitty |
| SUPER+SHIFT+W | следующие обои + палитра |
| `<leader>e` (nvim) | nvim-tree |
