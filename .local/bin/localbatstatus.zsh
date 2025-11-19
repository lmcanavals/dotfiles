#!/usr/bin/env zsh

get_battery_status() {
	declare -a BATTERY_ICONS=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
	local CHARGING_ICON="󱐋"
	local LOW_WARNING_ICON="!󰚥"
	local FULL_PLUGGED_ICON="󱐥"
	local BATTERY_PATH=$(upower -e | grep 'BAT' | head -n 1)

	if [[ -z "$BATTERY_PATH" ]]; then
		echo "No battery found"
		return 1
	fi

	local BATTERY_INFO=$(upower -i $BATTERY_PATH | grep -E "state|percentage|online")

	local PERCENTAGE=$(echo "$BATTERY_INFO" | awk '/percentage:/ {print $2}' | tr -d '%')
	local STATUS_RAW=$(echo "$BATTERY_INFO" | awk '/state:/ {print $2}')
	local IS_ONLINE=$(echo "$BATTERY_INFO" | awk '/online:/ {print $2}') # 'yes' or 'no'

	local ICON_INDEX=$(printf "%d\n" $(($PERCENTAGE / 9.1 + 1)))
	local BASE_ICON=${BATTERY_ICONS[$ICON_INDEX]}

	local FINAL_ICON=""
	local FINAL_STATUS=""

	if [[ "$STATUS_RAW" == "fully-charged" && "$IS_ONLINE" == "yes" ]]; then
		FINAL_ICON="$BASE_ICON$FULL_PLUGGED_ICON"
		FINAL_STATUS="Full"
	elif [[ "$STATUS_RAW" == "charging" ]]; then
		FINAL_ICON="$BASE_ICON$CHARGING_ICON"
		FINAL_STATUS="Charging"
	elif [[ "$STATUS_RAW" == "discharging" && "$PERCENTAGE" -lt 25 ]]; then
		FINAL_ICON="$BASE_ICON$LOW_WARNING_ICON"
		FINAL_STATUS="Low"
	else
		FINAL_ICON="$BASE_ICON"
		FINAL_STATUS="$(echo "$STATUS_RAW" | sed 's/\b\(.\)/\u\1/g')"
	fi

	echo "${FINAL_ICON} ${PERCENTAGE}% ${FINAL_STATUS}"
}

get_battery_status
