#!/bin/bash

# based on https://gitlab.com/Nmoleo/i3-volume-brightness-indicator

notification_timeout=1000
download_album_art=true
show_album_art=true
show_music_in_volume_indicator=true

# TODO: zsh this thing

function get_volume_icon {
	local mute=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | rg -Po 'MUTED')
	local icon
	if [ "$1" -eq 0 ] || [ "$mute" == "MUTED" ]; then
		icon=""
	elif [ "$1" -lt 50 ]; then
		icon=""
	else
		icon=""
	fi
	echo $icon
}

function get_mic_icon {
	local mute=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | rg -Po 'MUTED')
	local icon
	if [ "$1" -eq 0 ] || [ "$mute" == "MUTED" ]; then
		icon="󰍭"
	else
		icon="󰍬"
	fi
	echo $icon
}

function get_brightness_icon {
	local idx=$((($1 * 8 + 5) / 90))
	local icons=("" "" "" "" "" "" "" "" "")
	echo ${icons[$idx]}
}

function get_album_art {
	local url=$(playerctl -f "{{mpris:artUrl}}" metadata)
	local album_art
	if [[ $url == "file://"* ]]; then
		album_art="${url/file:\/\//}"
	elif [[ $url == "http://"* ]] ||
		[[ $url == "https://"* ]] &&
		[[ $download_album_art == "true" ]]; then
		local filename="$(echo $url | sed "s/.*\///")"

		if [ ! -f "/tmp/$filename" ]; then
			curl -o "/tmp/$filename" "$url"
		fi

		album_art="/tmp/$filename"
	else
		album_art="audio-speakers"
	fi
	echo $album_art
}

function show_volume_notif {
	local volume_icon=$(get_volume_icon $1)

	if [[ $show_music_in_volume_indicator == "true" ]]; then
		local current_song=$(playerctl -f "{{title}}<br><b>{{artist}}</b>" metadata)

		if [[ $show_album_art == "true" ]]; then
			local album_art=$(get_album_art)
		fi

		fyi --hint=string:x-dunst-stack-tag:volume_notif --hint=int:value:$1 \
			-i "$album_art" -t $notification_timeout "$1% $volume_icon" "$current_song"
	else
		fyi --hint=string:x-dunst-stack-tag:volume_notif --hint=int:value:$1 \
			-i audio-speakers -t $notification_timeout "$1% $volume_icon"
	fi
}

function show_mic_notif {
	local mic_icon=$(get_mic_icon $1)
	fyi --hint=string:x-dunst-stack-tag:mic_notif --hint=int:value:$1 \
		-i audio-input-microphone -t $notification_timeout "$1% $mic_icon"
}

function show_music_notif {
	local ready=false
	for ((i = 1; i <= 15; i++)); do
		status=$(playerctl status 2>/dev/null)
		if [ "$status" != "Stopped" ] && [ -n "$status" ]; then
			ready=true
			break
		fi
		sleep 0.1
	done
	local album_art="music"
	if not $ready; then
		fyi --hint=string:x-dunst-stack-tag:music_notif -i \
			"$album_art" -t $notification_timeout "Playerctl" "isn't ready"
	fi
	local song_title=$(playerctl -f "{{title}}" metadata)
	local song_artist=$(playerctl -f "{{artist}}" metadata)
	local song_album=$(playerctl -f "{{album}}" metadata)

	if [[ $show_album_art == "true" ]]; then
		local album_art=$(get_album_art)
	fi
	if [[ -n "$song_album" ]]; then
		song_album="<br><b>$song_album</b>"
	fi

	fyi --hint=string:x-dunst-stack-tag:music_notif \
		-i "$album_art" -t $notification_timeout "$song_title" "$song_artist$song_album"
}

function show_brightness_notif {
	local brightness=$(brightnessctl i | rg -Po '[0-9]{1,3}(?=%)' | head -n 1)
	local brightness_icon=$(get_brightness_icon $brightness)
	fyi --hint=string:x-dunst-stack-tag:brightness_notif --hint=int:value:$brightness \
		-i display -t $notification_timeout "$brightness% $brightness_icon"
}

function volbri() {
	local volume_step=5
	local brightness_step=1
	local max_volume=100

	# get audio device
	case $1 in
	mic_down | mic_mute | mic_up) local device="@DEFAULT_SOURCE@" ;;
	volume_down | volume_mute | volume_up) local device="@DEFAULT_SINK@" ;;
	esac

	# get and update volume for device
	case $1 in
	mic_down | mic_mute | mic_up | volume_down | volume_mute | volume_up)
		local volume=$(wpctl get-volume $device | awk '{printf "%.0f\n", $2 * 100}')
		;;
	esac

	# calculate new volume level
	case $1 in
	mic_down | volume_down) volume=$((volume - volume_step)) ;;
	mic_up | volume_up)
		volume=$((volume + volume_step))
		if [ $volume -gt $max_volume ]; then
			volume=$max_volume
		fi
		;;
	esac

	# update values
	case $1 in
	brightness_down) brightnessctl set $brightness_step%- ;;
	brightness_up) brightnessctl set $brightness_step%+ ;;
	mic_down | mic_up | volume_down | volume_up) wpctl set-volume $device $volume% ;;
	mic_mute | volume_mute) wpctl set-mute $device toggle ;;
	esac

	# showing notifs
	case $1 in
	mic_down | mic_mute | mic_up) show_mic_notif $volume ;;
	volume_down | volume_mute | volume_up) show_volume_notif $volume ;;
	brightness_down | brightness_up) show_brightness_notif ;;
	esac

	# media player control
	case $1 in
	next_track)
		playerctl next
		show_music_notif
		;;

	prev_track)
		playerctl previous
		show_music_notif
		;;

	play_pause)
		playerctl play-pause
		show_music_notif
		;;

	play_stop)
		show_music_notif
		playerctl stop
		;;
	esac
}

volbri $@
