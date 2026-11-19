#!/usr/bin/env bash
# Pre-render the blurred lockscreen background (so swaylock doesn't blur at lock time).
# Usage: make-bg.sh [source-image]   (defaults to the current wallpaper)
src=${1:-$HOME/Pictures/wallpapers/wallhaven-rqjgym.png}
out=$HOME/.cache/swaylock-bg.jpg
mkdir -p "$(dirname "$out")"
ffmpeg -y -loglevel error -i "$src" \
    -vf "scale=1920:-1,gblur=sigma=14,eq=brightness=-0.10:saturation=1.1,vignette=PI/5" \
    -q:v 3 "$out" && echo "wrote $out"
