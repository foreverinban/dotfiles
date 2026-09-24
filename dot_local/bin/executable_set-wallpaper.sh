#!/usr/bin/env bash
# Устарело: обои и палитру теперь ставит rice-apply. Оставлено как совместимая обёртка.
#   set-wallpaper.sh            -> переприменить текущие
#   set-wallpaper.sh <картинка> -> поставить конкретную
exec "$HOME/.local/bin/rice-apply" "${1:---reload}"
