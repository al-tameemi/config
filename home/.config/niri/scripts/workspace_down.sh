#!/run/current-system/sw/bin/bash

swww img $HOME/Pictures/wallhaven-vq898p.png -t grow --transition-duration 0.5 --transition-fps 60 --transition-pos bottom &

niri msg action focus-workspace-down &
wait
