#!/usr/bin/env bash
# wallpaper-watcher — ротация обоев по пулу + подхват новых мониторов.
#  * при старте (логин): rice-apply --next (если ROTATE_ON_LOGIN=1), иначе текущие
#  * раз в ROTATE_INTERVAL: rice-apply --next (проверка каждые 10 мин — переживает suspend)
#  * событие monitoraddedv2 из .socket2.sock: ставим текущие обои на новый монитор
export PATH="$HOME/.local/bin:$PATH"
CONF="$HOME/.config/rice/rice.conf"
[ -f "$CONF" ] && source "$CONF"
ROTATE_INTERVAL="${ROTATE_INTERVAL:-86400}"
ROTATE_ON_LOGIN="${ROTATE_ON_LOGIN:-1}"
CACHE="$HOME/.cache/rice"
CUR="$CACHE/wallpaper"
SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# одна копия на сессию
exec 8>"$XDG_RUNTIME_DIR/wallpaper-watcher.lock"
flock -n 8 || exit 0

# ждём hyprpaper IPC
for _ in $(seq 1 30); do
    hyprctl hyprpaper listactive >/dev/null 2>&1 && break
    sleep 0.5
done

if [ "$ROTATE_ON_LOGIN" = "1" ] || [ ! -e "$CUR" ]; then
    "$HOME/.local/bin/rice-apply" --next
else
    "$HOME/.local/bin/rice-apply" --reload
fi

# таймер ротации
(
    while sleep 600; do
        last=$(cat "$CACHE/last-rotate" 2>/dev/null || echo 0)
        if [ $(( $(date +%s) - last )) -ge "$ROTATE_INTERVAL" ]; then
            "$HOME/.local/bin/rice-apply" --next >/dev/null
        fi
    done
) &
TIMER_PID=$!
trap 'kill $TIMER_PID 2>/dev/null' EXIT

# новые мониторы
nc -U "$SOCK" | while read -r line; do
    if [[ "$line" == monitoraddedv2* ]]; then
        name=$(echo "$line" | cut -d'>' -f3 | cut -d',' -f2)
        sleep 1
        hyprctl hyprpaper wallpaper "$name,$(readlink -f "$CUR"),cover"
    fi
done
