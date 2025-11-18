#!/usr/bin/env zsh

# This function controls wf-recorder, handling start, stop, and notification.
#
# Global variable `SLURP_ARGS` used in the script, assumed to contain space-separated
# arguments for `slurp`.
#
# Example for hyprland on `hyprland.conf` add:
#   env = SLURP_ARGS, -d -c 000000aa
do_the_thing() {
	local stop
	local recinfo="/tmp/lmcs_wf_recorder_pid"
	zparseopts -E {-stop,s}=stop

	if (($#stop > 0)); then
		if [[ -f $recinfo ]]; then
			local PID filename
			read -r PID filename <$recinfo
			rm $recinfo
			kill $PID 2>/dev/null
			if (($? == 0)); then
				local thumbnail_name="/tmp/${filename:t:r}.jpg"
				time -p timeout 5s ffmpegthumbnailer -i "$filename" -o "$thumbnail_name" 2>/dev/null
				notify-send -i "$thumbnail_name" "Video saved" "$filename"
			else
				notify-send -i camera "Screen recorder" "Nothing to stop."
			fi
		else
			notify-send -i camera "Screen recorder" "No recording in progress."
		fi
		return 0
	fi

	local filename
	zparseopts -E {-file,f}:=filename
	filename="${filename[2]:-video$(date '+%Y%m%d_%H%M%S_%N').mp4}"

	local slurparr=($SLURP_ARGS)
	local wfargs=("-g")
	local region
	zparseopts -E {-region,r}=region

	if (($#region == 0)); then
		slurparr+=("-o" "-f" "%o")
		wfargs=("-o")
	fi

	wf-recorder $wfargs "$(slurp "${slurparr[@]}")" -f "$filename" &

	print -r "$! $filename" >$recinfo

	notify-send \
		-i camera "Screen recorder" "Recording $filename\nTo stop run '$ZSH_ARGZERO -s'"
}

do_the_thing "$@"
