#!/usr/bin/env zsh

coollock() {
	outputs=($(hyprctl -j monitors | jq -r '.[].name'))

	for output in "${outputs[@]}"; do
		filename="/tmp/${output}-lockscreen.png"
		spots -s 14 <(grim -o "$output" -) "$filename"
	done
}
coollock
pidof hyprlock || hyprlock --grace 5
