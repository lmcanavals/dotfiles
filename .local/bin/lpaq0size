#!/usr/bin/env zsh

paq0size() {
	for paq in $(pacman -Qqs); do
		pacman -Qi $paq | grep "Installed Size  : 0"
		if [ $? -eq 0 ]; then
			echo $paq
		fi
	done
}
pac0size
