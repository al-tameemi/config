#!/run/current-system/sw/bin/bash

swww img $HOME/Pictures/wallhaven-x6x3gz.png -t grow --transition-duration 0.5 --transition-fps 60 --transition-pos top &

niri msg action focus-workspace-up &
wait
