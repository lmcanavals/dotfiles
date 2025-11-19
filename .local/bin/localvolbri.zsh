#!/bin/bash

# based on https://gitlab.com/Nmoleo/i3-volume-brightness-indicator

volume_step=5
brightness_step=1
max_volume=100
notification_timeout=1000
download_album_art=true
show_album_art=true
show_music_in_volume_indicator=true

# TODO: when wpctl makes it easier to get this info, migrate to it
# TODO: zsh this thing
function get_volume {
	pactl get-sink-volume @DEFAULT_SINK@ | rg -Po '[0-9]{1,3}(?=%)' | head -1
}

function get_mute {
	pactl get-sink-mute @DEFAULT_SINK@ | rg -Po '(?<=Mute: )(yes|no)'
}

function get_mic_vol {
	pactl get-source-volume @DEFAULT_SOURCE@ | rg -Po '[0-9]{1,3}(?=%)' | head -1
}

function get_mic_mute {
	pactl get-source-mute @DEFAULT_SOURCE@ | rg -Po '(?<=Mute: )(yes|no)'
}

function get_brightness {
	brightnessctl i | rg -Po '[0-9]{1,3}(?=%)' | head -n 1
}

function get_volume_icon {
	volume=$(get_volume)
	mute=$(get_mute)
	if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ]; then
		volume_icon=""
	elif [ "$volume" -lt 50 ]; then
		volume_icon=""
	else
		volume_icon=""
	fi
}

function get_mic_icon {
	volume=$(get_mic_vol)
	mute=$(get_mic_mute)
	if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ]; then
		volume_icon="󰍭"
	else
		volume_icon="󰍬"
	fi
}

function get_brightness_icon {
	brightness=$(get_brightness)
	if [ "$brightness" -lt 11 ]; then
		brightness_icon=""
	elif [ "$brightness" -lt 22 ]; then
		brightness_icon=""
	elif [ "$brightness" -lt 33 ]; then
		brightness_icon=""
	elif [ "$brightness" -lt 44 ]; then
		brightness_icon=""
	elif [ "$brightness" -lt 55 ]; then
		brightness_icon=""
	elif [ "$brightness" -lt 66 ]; then
		brightness_icon=""
	elif [ "$brightness" -lt 77 ]; then
		brightness_icon=""
	elif [ "$brightness" -lt 88 ]; then
		brightness_icon=""
	else
		brightness_icon=""
	fi

}

function get_album_art {
	url=$(playerctl -f "{{mpris:artUrl}}" metadata)
	if [[ $url == "file://"* ]]; then
		album_art="${url/file:\/\//}"
	elif [[ $url == "http://"* ]] && [[ $download_album_art == "true" ]]; then
		filename="$(echo $url | sed "s/.*\///")"

		if [ ! -f "/tmp/$filename" ]; then
			wget -O "/tmp/$filename" "$url"
		fi

		album_art="/tmp/$filename"
	elif [[ $url == "https://"* ]] && [[ $download_album_art == "true" ]]; then
		filename="$(echo $url | sed "s/.*\///")"

		if [ ! -f "/tmp/$filename" ]; then
			wget -O "/tmp/$filename" "$url"
		fi

		album_art="/tmp/$filename"
	else
		album_art="audio-speakers"
	fi
}

function show_volume_notif {
	volume=$(get_mute)
	get_volume_icon

	if [[ $show_music_in_volume_indicator == "true" ]]; then
		current_song=$(playerctl -f "{{title}} - {{artist}}" metadata)

		if [[ $show_album_art == "true" ]]; then
			get_album_art
		fi

		notify-send \
			-h string:x-dunst-stack-tag:volume_notif \
			-h int:value:$volume \
			-i "$album_art" \
			-t $notification_timeout \
			"$volume% $volume_icon" \
			"$current_song"
	else
		notify-send \
			-h string:x-dunst-stack-tag:volume_notif \
			-h int:value:$volume \
			-i audio-speakers \
			-t $notification_timeout \
			"$volume% $volume_icon"
	fi
}

function show_mic_notif {
	volume=$(get_mic_mute)
	get_mic_icon
	notify-send \
		-h string:x-dunst-stack-tag:mic_notif \
		-h int:value:$volume \
		-i audio-input-microphone \
		-t $notification_timeout \
		"$volume% $volume_icon"
}

function show_music_notif {
	song_title=$(playerctl -f "{{title}}" metadata)
	song_artist=$(playerctl -f "{{artist}}" metadata)
	song_album=$(playerctl -f "{{album}}" metadata)

	if [[ $show_album_art == "true" ]]; then
		get_album_art
	fi

	notify-send \
		-h string:x-dunst-stack-tag:music_notif \
		-i "$album_art" \
		-t $notification_timeout \
		"$song_title" \
		"$song_artist - $song_album"
}

function show_brightness_notif {
	brightness=$(get_brightness)
	echo $brightness
	get_brightness_icon
	notify-send \
		-h string:x-dunst-stack-tag:brightness_notif \
		-h int:value:$brightness \
		-i display \
		-t $notification_timeout \
		"$brightness% $brightness_icon"
}

case $1 in
volume_up)
	wpctl set-mute @DEFAULT_SINK@ 0
	volume=$(get_volume)
	if [ $(("$volume" + "$volume_step")) -gt $max_volume ]; then
		wpctl set-volume @DEFAULT_SINK@ $max_volume%
	else
		wpctl set-volume @DEFAULT_SINK@ $volume_step%+
	fi
	show_volume_notif
	;;

volume_down)
	wpctl set-volume @DEFAULT_SINK@ $volume_step%-
	show_volume_notif
	;;

volume_mute)
	wpctl set-mute @DEFAULT_SINK@ toggle
	show_volume_notif
	;;

mic_up)
	wpctl set-mute @DEFAULT_SOURCE@ 0
	volume=$(get_mic_vol)
	if [ $(("$volume" + "$volume_step")) -gt $max_volume ]; then
		wpctl set-volume @DEFAULT_SOURCE@ $max_volume%
	else
		wpctl set-volume @DEFAULT_SOURCE@ $volume_step%+
	fi
	show_mic_notif
	;;

mic_down)
	wpctl set-volume @DEFAULT_SOURCE@ $volume_step%-
	show_mic_notif
	;;

mic_mute)
	wpctl set-mute @DEFAULT_SOURCE@ toggle
	show_mic_notif
	;;

brightness_up)
	brightnessctl set $brightness_step%+
	show_brightness_notif
	;;

brightness_down)
	brightnessctl set $brightness_step%-
	show_brightness_notif
	;;

next_track)
	playerctl next
	sleep 0.5 && show_music_notif
	;;

prev_track)
	playerctl previous
	sleep 0.5 && show_music_notif
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
