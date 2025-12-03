#!/usr/bin/env zsh

# lmcsshot: Flexible Wayland Screenshot Utility
# Captures full screen, region, monitor, or active window (via grim/slurp/hyprctl).
# Features include timed delay, clipboard copy, file save, editor launch (Swappy/GIMP),
# and notification with a thumbnail. Requires wl-copy, jq, and vipsthumbnail.
# TODO: add a --quiet or --notification off to suppress the notification

print_usage() {
	cat <<- EOF
Usage: lmcsshot [OPTIONS]

	Flexible Wayland Screenshot Utility using grim, slurp, and hyprctl.
	Output is written to a file by default, unless -c or -e are used.

	Options:
		-r, --region             Capture a user-selected region (uses slurp).
		-o, --output             Capture a single monitor output (uses slurp).
		-w, --window             Capture the active window (uses hyprctl).
		-m, --mouse              Capture cursor (passes -c flag to grim).
		-d <sec>, --delay=<sec>  Delay capture by <sec> seconds (default 1).
		
		-f <path>, --file=<path> Save output to <path> (default: /tmp/screenshot...).
		-e <cmd>, --edit=<cmd>   Launch editor <cmd> after capture.
		-c, --copy               Copy the image to the clipboard (wl-copy).

		-h, --help               Show this help message.
EOF
}

lmcsshot() {
	local help
	zparseopts -E {-help,h}=help
	if (($#relp > 0)); then
		print_usage
		return 0
	fi

	local options=("")
	local mouse
	zparseopts -E {-mouse,m}=mouse
	if (($#mouse > 0)); then
		options+=("-c")
	fi

	local slurp_args=(${=SLURP_ARGS})
	local output region window slurp_result
	zparseopts -E {-output,o}=output {-region,r}=region {-window,w}=window

	# 1. Capture slurp/geometry result
	if (($#output > 0)); then
		slurp_args+=("-o" "-f" "%o")
		options+=("-o")
		slurp_result="$(slurp "${slurp_args[@]}")"
	elif (($#region > 0)); then
		options+=("-g")
		slurp_result="$(slurp "${slurp_args[@]}")"
	fi

	if [[ $? -ne 0 ]]; then
		return 1 # Stop if slurp was cancelled
	fi

	# 2. Handle delay
	local delay
	zparseopts -E {-delay,d}:=delay
	if (($#delay > 1)); then
		sleep ${delay[2]:-1}
	fi

	# 3. Handle active window capture
	if (($#window > 0)); then
		slurp_result=$(hyprctl activewindow -j |
			jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' 2>/dev/null)
		if [[ -z "$slurp_result" ]]; then
			notify-send -i image "Screenshot error" "No active window found for capture."
			return 1
		fi
		options+=("-g")
	fi

	# 4. Append final geometry/monitor argument to options array
	if (($#output > 0 || $#region > 0 || $#window)); then
		options+=("$slurp_result")
	fi

	# 5. Filename and output destination parsing
	local filename
	zparseopts -E {-file,f}:=filename
	filename="${filename[2]:-/tmp/screenshot$(date '+%Y%m%d_%H%M%S_%N').png}"
	options+=("$filename")
	grim ${options[@]}
	local thumbnail="/tmp/${filename:t:r}_thumb.png"
	vipsthumbnail --size=128 --crop -o "$thumbnail" "$filename"

	# 6. Post-Capture Action: Edit or Copy
	local title="Oooh weee! screenshot..."
	local image_editor copy
	zparseopts -E {-edit,e}:=image_editor {-copy,c}=copy
	if (($#image_editor > 0)); then
		local final_command="${image_editor[2]} $filename"
		final_command=(${=final_command})
		title="Editing screenshot..."
		uwsm-app -- ${final_command[@]}
	elif (($#copy > 0)); then
		title="Screenshot loaded to clipboard and..."
		wl-copy < $filename
	fi
	notify-send -i "$thumbnail" $title "Saved to $filename"
}

lmcsshot "$@"
