#!/usr/bin/env bash
notify() { command -v notify-send >/dev/null && notify-send "$@"; return 0; }
# Pick a Wi-Fi network with fuzzel and connect via NetworkManager.
nmcli radio wifi on
notify -t 1500 "Wi-Fi" "Scanning…" 2>/dev/null
nmcli device wifi rescan 2>/dev/null; sleep 1

list=$(nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list --rescan no \
    | awk -F: '$2 != "" && !seen[$2]++ {
        printf "%s %s  (%s%%) %s\n", ($1=="*" ? "●" : " "), $2, $3, ($4=="" ? "" : "🔒")
    }')
[[ -z $list ]] && { notify "Wi-Fi" "No networks found"; exit 1; }

choice=$(printf '%s\n' "$list" "󰖪  Disable Wi-Fi" | fuzzel --dmenu -p "Wi-Fi ❯ " -w 45) || exit 0
[[ $choice == *"Disable Wi-Fi" ]] && { nmcli radio wifi off; exit 0; }

ssid=$(sed -E 's/^. (.*)  \([0-9]+%\).*$/\1/' <<<"$choice")

# Known network: just bring it up. Otherwise ask for a password if needed.
if nmcli -t -f NAME connection show | grep -qxF "$ssid"; then
    nmcli connection up id "$ssid"
elif [[ $choice == *"🔒"* ]]; then
    pass=$(fuzzel --dmenu --password -l 0 -p "Password for $ssid ❯ ") || exit 0
    nmcli device wifi connect "$ssid" password "$pass"
else
    nmcli device wifi connect "$ssid"
fi && notify "Wi-Fi" "Connected to $ssid" || notify "Wi-Fi" "Failed to connect to $ssid"
