#!/usr/bin/env zsh

COLOR_ADDED="#0db9d7"
COLOR_CLEAN="#41a6b5"
COLOR_DELETED="#db4b4b"
COLOR_DIVERGED="#ff9e64"
COLOR_MODIFIED="#e0af68"
COLOR_STAGED="#6183bb"
COLOR_UNTRACKED="#9d7cd8"

ICON_AHEAD=$'\uf093'     # 
ICON_BEHIND=$'\uf019'    # 
ICON_BRANCH=$'\uf126'    # 
ICON_CHECK=$'\uf1d2'     # 
ICON_COMMITTED=$'\ue729' # 
ICON_DIVERGED=$'\ue728'  # 
ICON_MODIFIED=$'\uf14b'  # 
ICON_UNTRACKED=$'\uf059' # 

#
tag() {
	echo -n "<span foreground=\\\"$1\\\">$2</span>"
}

# Generates a compact, symbolic string representing the current Git repository status.
# Output is formatted using Pango markup for use in Waybar.
dotfiles_status() {
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
		output+=" $(tag $COLOR_DIVERGED $ICON_DIVERGED)"
	elif ((ahead > 0)); then
		output+=" $(tag $COLOR_ADDED "$ICON_AHEAD $ahead")"
	elif ((behind > 0)); then
		output+=" $(tag $COLOR_DELETED "$ICON_BEHIND $behind")"
	fi

	# 4. Count files in various states using --porcelain output (from line 2 onwards)
	local unstaged_output=$(echo "$status_line" | tail -n +2)
	local staged_count=$(echo "$unstaged_output" | grep -E '^[MARCUD]{1}' | wc -l)
	local modified_count=$(echo "$unstaged_output" | grep -E '^.[MD]' | wc -l)
	local untracked_count=$(echo "$unstaged_output" | grep -E '^\?\?' | wc -l)

	# 5. Append symbols based on counts
	if ((staged_count > 0)); then
		output+="\r$(tag $COLOR_STAGED "$ICON_COMMITTED $staged_count staged") "
	fi
	if ((modified_count > 0)); then
		output+="\r$(tag $COLOR_MODIFIED "$ICON_MODIFIED $modified_count modified") "
	fi
	if ((untracked_count > 0)); then
		output+="\r$(tag $COLOR_UNTRACKED "$ICON_UNTRACKED $untracked_count untracked")"
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

#    
ICON_H0=$'\uf4c3' # 
ICON_H1=$'\uf444' # 
ICON_M0=$'\uf4c3' # 
ICON_M1=$'\uf444' # 
HOUR=({$ICON_H0,$ICON_H1}{$ICON_H0,$ICON_H1}{$ICON_H0,$ICON_H1}{$ICON_H0,$ICON_H1}{$ICON_H0,$ICON_H1})
MINUTE=({$ICON_M0,$ICON_M1}{$ICON_M0,$ICON_M1}{$ICON_M0,$ICON_M1}{$ICON_M0,$ICON_M1}{$ICON_M0,$ICON_M1}{$ICON_M0,$ICON_M1})

cool_time() {
	local hour=$(date +%H)
	local minute=$(date +%M)
	local second=$(date +%S)

	text="\"text\": \"<b>${HOUR[$hour + 1]}</b>:${MINUTE[$minute + 1]}\""
	tooltip="\"tooltip\": \"$(dotfiles_status)\""
	echo "{$text,$tooltip}"
}

lmcsbinclock() {
	local once
	zparseopts -E {-once,o}=once
	if (($#once > 0)); then
		cool_time
		return 0
	fi
	while :; do
		cool_time
		sleep 10
	done
}

lmcsbinclock $@
