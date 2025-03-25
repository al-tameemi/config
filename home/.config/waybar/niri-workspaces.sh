#!/run/current-system/sw/bin/bash
set -e

monitor=$1

active="1"
inactive="0"

workspace_str=""

msg_out="$(niri msg -j workspaces | jq ".[] | select(.output == \"$monitor\") | .is_active")"
for ws in $msg_out; do
	if "$ws"; then
		workspace_str="${workspace_str}${active}  "
	else
		workspace_str="${workspace_str}${inactive}  "
	fi
done

printf "%s" "$workspace_str"

