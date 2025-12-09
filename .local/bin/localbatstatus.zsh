#!/usr/bin/env zsh

get_battery_status() {
	declare -a battery_normal=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
	declare -a battery_charging=("󰢟" "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")
	local icon_low="󱃍"
	local icon_plugged=""
	local battery_path=$(upower -e | grep 'BAT' | head -n 1)

	if [[ -z "$battery_path" ]]; then
		echo "󰂑 not found"
		return 1
	fi

	local battery_info=$(upower -i $battery_path | grep -E "state|percentage|present")
	local percentage=$(echo "$battery_info" | awk '/percentage:/ {print $2}' | tr -d '%')
	local state=$(echo "$battery_info" | awk '/state:/ {print $2}')
	local present=$(echo "$battery_info" | awk '/present:/ {print $2}') # 'yes' or 'no'

	local icon_idx=$(printf "%d\n" $(($percentage / 9.1 + 1)))

	local output=""

	if [[ "$state" == "fully-charged" && "$present" == "yes" ]]; then
		output="$icon_plugged battery full"
	elif [[ "$state" == "charging" ]]; then
		output="${battery_charging[$icon_idx]} $percentage%"
	elif [[ "$state" == "discharging" && "$percentage" -lt 25 ]]; then
		output="<span color=\"${LCLR:24:7}\">$icon_low $percentage% </span>"
	else
		output="${battery_normal[$icon_idx]} $percentage% $state"
	fi

	echo "${output}"
}

get_battery_status
