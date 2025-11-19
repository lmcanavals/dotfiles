#!/usr/bin/env zsh

# Emojis! go

wofoji() {
	local jsoji=https://raw.githubusercontent.com/muan/emojilib/refs/heads/main/dist/emoji-en-US.json
	local cacheji=$XDG_DATA_HOME/emojicache.txt
	if [[ ! -f "$cacheji" ]]; then
		curl $jsoji | jq -r 'to_entries[] | "\(.key) \(.value | join(" "))"' >$cacheji
	fi

	local emoji=$(wofi -p "🦃 emojis" -iIS dmenu <$cacheji | awk '{printf "%s", $1}')
	wl-copy "$emoji"
	wtype "$emoji"
}

wofoji
