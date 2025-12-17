#!/usr/bin/env zsh

# Emojis! go

wofoji() {
	local jsoji=https://raw.githubusercontent.com/muan/emojilib/refs/heads/main/dist/emoji-en-US.json
	local cacheji=$XDG_DATA_HOME/emojicache.txt
	if [[ ! -f "$cacheji" ]]; then
		curl $jsoji | jq -r 'to_entries[] | "\(.key) \(.value | join(" "))"' >$cacheji
	fi

	local emoji=$(fuzzel --placeholder "🦃 emojis" --dmenu <$cacheji | awk '{printf "%s", $1}')
	wl-copy "$emoji"
	wl-copy -p "emoji"
	# simulating a paste because directly wtyping doesn't work on chromium based stuff
	wtype -M shift -k Insert -m shift
}

wofoji
