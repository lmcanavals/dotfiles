#!/usr/bin/env zsh

mkmotd() {
	#define the filename to use as output
	local motd="/etc/motd"
	# Collect useful information about your system
	# $USER is automatically defined
	local HOSTNAME=$(uname -n)
	local KERNEL=$(uname -r)
	local ARCH=$(uname -m)
	local CPU=$(uname -p)
	# The different colours as variables
	local R="\033[1;31m"
	local Y="\033[1;33m"
	local B="\033[1;36m"
	local W="\033[1;37m"
	local X="\033[0;37m"
	clear >$motd # to clear the screen when showing up
	echo -e "$B        ." >>$motd
	echo -e "$B       /#\\" >>$motd
	echo -e "$B      /###\\     $W                #    $B | o" >>$motd
	echo -e "$B     /p^###\\    $W  a##e #%\" a#\"e 6##% $B | | |-^-. |   | \\ /" >>$motd
	echo -e "$B    /##P^q##\\   $W .oOo# #   #    #  # $B | | |   | |   |  X" >>$motd
	echo -e "$B   /##(   )##\\  $W %OoO# #   %#e\" #  # $B | | |   | ^._.| / \\ ${X}TM" >>$motd
	echo -e "$B  /###P   q#,^\\" >>$motd
	echo -e "$B /P^         ^q\\ ${X}TM\t$R$HOSTNAME $KERNEL $ARCH" >>$motd
	echo -e "\033[0m" >>$motd
}
mkmotd
