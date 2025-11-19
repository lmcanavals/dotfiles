#!/usr/bin/env zsh

dec_to_base() {
	printf "%0$1s\n" "$(echo "obase=$2;$3" | bc)" |
		sed 's/[ 0]/\\ueabc/g' |
		sed 's/1/\\uea71/g'
}

cool_time() {
	hour=$(date +%H)
	minute=$(date +%M)
	second=$(date +%S)

	hour=$(dec_to_base 6 2 $hour)
	minute=$(dec_to_base 6 2 $minute)
	#second=$(dec_to_base 6 $second)
	#base="╸┛┓┫" # "🬋🬌🬚🬛━┻┳╋"
	#codedtime=""
	#for i in {1..6}; do
	#	h=$hour[i]
	#	m=$minute[i]
	#	p="$(($m * 2 + $h + 1))"
	#	codedtime="${codedtime}${base[p]}"
	#done
	#echo "$codedtime"
	text="\"text\": \"$hour $minute\""
	tooltip="\"tooltip\": \"coming soon...\""
	echo "{$text,$tooltip}"
}

cool_time
