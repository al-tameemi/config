#!/usr/bin/env bash
# Prints default input (microphone) state as waybar JSON.
on="<span size='large'>\\uf130</span>"
off="<span size='large'>\\uf131</span>"
out=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null) || { printf '{"text":"%s n/a","class":"muted"}\n' "$off"; exit 0; }
vol=$(awk '{printf "%d", $2*100}' <<<"$out")
if [[ $out == *MUTED* ]]; then
    printf '{"text":"%s muted","class":"muted","tooltip":"Microphone muted"}\n' "$off"
else
    printf '{"text":"%s %s%%","class":"","tooltip":"Microphone %s%%"}\n' "$on" "$vol" "$vol"
fi
