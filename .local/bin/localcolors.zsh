#!/usr/bin/zsh

function printnum() {
	printf "%3s" "$1"
}

function printcolors() {

	# Basic ansi + brights
	echo " *** Basic ANSI + Bright colors. Range from 0 to 15"
	oline="  x"
	for (( i = 0; i < 16; i++))
	do
		oline="$oline$(printnum $i)"
	done
	echo $oline
	for (( i = 0; i < 16; i++ ))
	do
		oline="$(printnum $i) "
		for (( j = 0; j < 16; j++ ))
		do
			oline="$oline[38;5;${i}m[48;5;${j}m ■ [0m"
		done
		echo $oline
	done
	echo ""

	# sandwiched colors in the 16..231 range
	echo " *** 6x6x6 rgb cube. Range from 16 to 231"
	oline="  +"
	for i in 0 1 2 3 4 5
	do
		oline="$oline$(printnum $i)"
	done
	echo "$oline  $oline  $oline"
	for i in 0 3
	do
		for j in 0 1 2 3 4 5
		do
			oline=""
			for k in 0 36 72
			do
				ccc=$((i*36 + j*6 + k + 16))
				oline="$oline$(printnum $ccc) "
				for l in 0 1 2 3 4 5
				do
					ccc=$((i * 36 + j * 6 + k + l + 16))
					oline="$oline[48;5;${ccc}m ■ [0m"
				done
				oline="$oline "
			done
			echo $oline
		done
		echo ""
	done

	# Gray scale
	echo " *** 24 gray scale colors. Range from 232 to 255"
	oline="  +"
	for (( i = 0; i < 24; i++ ))
	do
		oline="$oline$(printnum $i)"
	done
	echo $oline
	ccc="232"
	oline="$(printnum $ccc) "
	for (( i = 0; i < 24; i++ ))
	do
		ccc=$(( i + 232 ))
		oline="$oline[48;5;${ccc}m ■ [0m"
	done
	echo $oline
}
printcolors
