#!/usr/bin/env bash
# Logout / reboot / poweroff menu via fuzzel.
choice=$(printf '%s\n' "󰍃  Logout" "󰜉  Reboot" "󰐥  Poweroff" \
    | fuzzel --dmenu -l 3 -w 20 -p "Power ❯ ") || exit 0

case $choice in
    *Logout)   niri msg action quit --skip-confirmation ;;
    *Reboot)   systemctl reboot ;;
    *Poweroff) systemctl poweroff ;;
esac
