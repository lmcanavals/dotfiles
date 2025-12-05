#!/usr/bin/env zsh

tag() {
	echo -n "<span foreground=\\\"$1\\\">$2</span>"
}

# Generates a compact, symbolic string representing the current Git repository status.
# Output is formatted using Pango markup for use in Waybar.
dotfiles_status() {
	local COLOR_ADDED="#0db9d7"
	local COLOR_CLEAN="#41a6b5"
	local COLOR_DELETED="#db4b4b"
	local COLOR_DIVERGED="#ff9e64"
	local COLOR_MODIFIED="#e0af68"
	local COLOR_STAGED="#6183bb"
	local COLOR_UNTRACKED="#9d7cd8"

	local ICON_AHEAD=$'\uf093'     # 
	local ICON_BEHIND=$'\uf019'    # 
	local ICON_BRANCH=$'\uf126'    # 
	local ICON_CHECK=$'\uf1d2'     # 
	local ICON_COMMITTED=$'\ue729' # 
	local ICON_DIVERGED=$'\ue728'  # 
	local ICON_MODIFIED=$'\uf14b'  # 
	local ICON_UNTRACKED=$'\uf059' # 

	local dotfiles=("--git-dir=$HOME/.dotfiles.git" "--work-tree=$HOME")

	# Check if we are inside a git repository
	if ! git ${dotfiles[@]} rev-parse --is-inside-work-tree &>/dev/null; then
		return 0
	fi

	# 1. Get the short, machine-readable status
	local status_line=$(git ${dotfiles[@]} status -u --porcelain=v1 --branch 2>/dev/null)

	# 2. Extract branch/remote information from the first line
	local branch_info=$(echo "$status_line" | head -n 1)

	local current_branch
	local ahead=0
	local behind=0
	local branch_color="$COLOR_CLEAN"

	# Parse branch name and remote status
	if [[ "$branch_info" =~ '##' ]]; then
		current_branch=$(echo "$branch_info" | sed -E 's/## ([^.]+).*/\1/')

		# Note: Zsh matches are stored in the 'match' array automatically.
		if [[ "$branch_info" =~ 'ahead ([0-9]+)' ]]; then
			ahead="${match[1]}"
		fi
		if [[ "$branch_info" =~ 'behind ([0-9]+)' ]]; then
			behind="${match[1]}"
		fi
	else
		# Detached HEAD case (or simple local branch without remote info)
		current_branch=$(git ${dotfiles[@]} rev-parse --short HEAD)
	fi

	# Set branch color based on dirty status or divergence
	if ((ahead > 0 || behind > 0)) || [[ -n "$(echo "$status_line" | tail -n +2)" ]]; then
		branch_color="$COLOR_MODIFIED"
	fi

	# Start the prompt string: [COLOR_BRANCH] [ICON] [BRANCH_NAME]
	local output="$(tag $branch_color "$ICON_BRANCH $current_branch")"

	# 3. Handle ahead/behind/diverged status
	if ((ahead > 0 && behind > 0)); then
		output+=" $(tag $COLOR_DIVERGED $ICON_DIVERGED)\r"
	elif ((ahead > 0)); then
		output+=" $(tag $COLOR_ADDED "$ICON_AHEAD $ahead")\r"
	elif ((behind > 0)); then
		output+=" $(tag $COLOR_DELETED "$ICON_BEHIND $behind")\r"
	fi

	# 4. Count files in various states using --porcelain output (from line 2 onwards)
	local unstaged_output=$(echo "$status_line" | tail -n +2)
	local staged_count=$(echo "$unstaged_output" | grep -E '^[MARCUD]{1}' | wc -l)
	local modified_count=$(echo "$unstaged_output" | grep -E '^.[MD]' | wc -l)
	local untracked_count=$(echo "$unstaged_output" | grep -E '^\?\?' | wc -l)

	# 5. Append symbols based on counts
	if ((staged_count > 0)); then
		output+="$(tag $COLOR_STAGED "$ICON_COMMITTED $staged_count staged") "
	fi
	if ((modified_count > 0)); then
		output+="$(tag $COLOR_MODIFIED "$ICON_MODIFIED $modified_count modified") "
	fi
	if ((untracked_count > 0)); then
		output+="$(tag $COLOR_UNTRACKED "$ICON_UNTRACKED $untracked_count untracked")"
	fi

	# 6. Final status (clean or dirty)
	if ((staged_count == 0 && modified_count == 0 && \
		untracked_count == 0 && ahead == 0 && behind == 0)); then
		output="$(tag $COLOR_CLEAN "<b>$ICON_CHECK files synced</b>")\r${output}"
	else
		output="$(tag $COLOR_MODIFIED "<b>$ICON_CHECK files out of sync</b>")\r${output}"
	fi

	echo -n "$output"
}

dec_to_base() {
	printf "%0$1s\n" "$(echo "obase=$2;$3" | bc)" |
		sed "s/[ 0]/$4/g" |
		sed "s/1/$5/g"
}

cool_time() {
	#    
	local ICON_H0=$'\uf4c3' # 
	local ICON_H1=$'\uf444' # 
	local ICON_M0=$'\uf4c3' # 
	local ICON_M1=$'\uf444' # 
	local hour=$(date +%H)
	local minute=$(date +%M)
	local second=$(date +%S)

	hour=$(dec_to_base 5 2 $hour $ICON_H0 $ICON_H1)
	minute=$(dec_to_base 6 2 $minute $ICON_M0 $ICON_M1)
	text="\"text\": \"<b>$hour</b>:$minute\""
	tooltip="\"tooltip\": \"$(dotfiles_status)\""
	echo "{$text,$tooltip}"
}

cool_time
