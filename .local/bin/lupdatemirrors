#!/usr/bin/env zsh

safeupdatemirrors() {
	local base="/etc/pacman.d"
	if [ -f $base/mirrorlist.pacnew ]; then
		local tempfile=$(mktemp)
		echo $tempfile
		sed '/#Server/ s|#|| ' -i $base/mirrorlist.pacnew
		sed '/^#.*$/d' -i $base/mirrorlist.pacnew
		cp $base/mirrorlist $tempfile
		rankmirrors -n 6 $base/mirrorlist.pacnew >$base/mirrorlist
		if [ $? -eq 0 ]; then
			rm $base/mirrorlist.pacnew
			echo "Mirror list updated"
		else
			cp $tempfile $base/mirrorlist
			echo "Failed to update mirror list"
		fi
		rm $tempfile
	else
		echo "There's no mirrorlist.pacnew. Doing nothing."
	fi
}
safeupdatemirrors
