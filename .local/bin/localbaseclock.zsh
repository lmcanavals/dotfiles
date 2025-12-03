#!/usr/bin/env zsh

# Description: Generates a compact, symbolic string representing the current Git repository status.
# Output is formatted using Pango markup for use in Waybar.
dotfiles_status() {
	local COLOR_ADDED="<span foreground=\\\"#0db9d7\\\">"
	local COLOR_CLEAN="<span foreground=\\\"#41a6b5\\\">"
	local COLOR_DELETED="<span foreground=\\\"#db4b4b\\\">"
	local COLOR_DIVERGED="<span foreground=\\\"#ff9e64\\\">"
	local COLOR_MODIFIED="<span foreground=\\\"#e0af68\\\">"
	local COLOR_RESET="</span>"
	local COLOR_STAGED="<span foreground=\\\"#6183bb\\\">"
	local COLOR_UNTRACKED="<span foreground=\\\"#9d7cd8\\\">"

	local SYMBOL_AHEAD=$'\uf093'     # 
	local SYMBOL_BEHIND=$'\uf019'    # 
	local SYMBOL_BRANCH=$'\uf126'    # 
	local SYMBOL_CHECK=$'\uf1d2'     # 
	local SYMBOL_COMMITTED=$'\ue729' # 
	local SYMBOL_DIVERGED=$'\ue728'  # 
	local SYMBOL_MODIFIED=$'\uf14b'  # 
	local SYMBOL_UNTRACKED=$'\uf059' # 

	local dotfiles=("--git-dir=$HOME/.dotfiles.git" "--work-tree=$HOME")

	# Check if we are inside a Git repository
	if ! git ${dotfiles[@]} rev-parse --is-inside-work-tree &>/dev/null; then
		return 0
	fi

	# 1. Get the short, machine-readable status
	local status_line=$(git ${dotfiles[@]} status --porcelain=v1 --branch 2>/dev/null)

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

	# Start the prompt string: [COLOR_BRANCH] [SYMBOL] [BRANCH_NAME]
	local output="${branch_color}${SYMBOL_BRANCH} ${current_branch}${COLOR_RESET} "

	# 3. Handle Ahead/Behind/Diverged Status
	if ((ahead > 0 && behind > 0)); then
		output+="${COLOR_DIVERGED}${SYMBOL_DIVERGED}${COLOR_RESET}\r"
	elif ((ahead > 0)); then
		output+="${COLOR_ADDED}${SYMBOL_AHEAD} ${ahead}${COLOR_RESET}\r"
	elif ((behind > 0)); then
		output+="${COLOR_DELETED}${SYMBOL_BEHIND} ${behind}${COLOR_RESET}\r"
	fi

	# 4. Count files in various states using --porcelain output (from line 2 onwards)
	local unstaged_output=$(echo "$status_line" | tail -n +2)
	local staged_count=$(echo "$unstaged_output" | grep -E '^[MARCUD]{1}' | wc -l)
	local modified_count=$(echo "$unstaged_output" | grep -E '^.[MD]' | wc -l)
	local untracked_count=$(echo "$unstaged_output" | grep -E '^\?\?' | wc -l)

	# 5. Append symbols based on counts
	if ((staged_count > 0)); then
		output+="${COLOR_STAGED}${SYMBOL_COMMITTED} ${staged_count} staged${COLOR_RESET} "
	fi
	if ((modified_count > 0)); then
		output+="${COLOR_MODIFIED}${SYMBOL_MODIFIED} ${modified_count} modified${COLOR_RESET} "
	fi
	if ((untracked_count > 0)); then
		output+="${COLOR_UNTRACKED}${SYMBOL_UNTRACKED} ${untracked_count} untracked${COLOR_RESET}"
	fi

	# 6. Final Status (Clean or Dirty)
	if ((staged_count == 0 && modified_count == 0 && untracked_count == 0 && ahead == 0 && behind == 0)); then
		output="<b>${COLOR_CLEAN}${SYMBOL_CHECK} files synced${COLOR_RESET}</b>\r${output}"
	else
		output="<b>${COLOR_MODIFIED}${SYMBOL_CHECK} files out of sync${COLOR_RESET}</b>\r${output}"
	fi

	echo -n "$output"
}

dec_to_base() {
	printf "%0$1s\n" "$(echo "obase=$2;$3" | bc)" |
		sed 's/[ 0]/\\ueabc/g' |
		sed 's/1/\\uea71/g'
}

cool_time() {
	local hour=$(date +%H)
	local minute=$(date +%M)
	local second=$(date +%S)

	hour=$(dec_to_base 6 2 $hour)
	minute=$(dec_to_base 6 2 $minute)
	text="\"text\": \"$hour $minute\""
	tooltip="\"tooltip\": \"$(dotfiles_status)\""
	echo "{$text,$tooltip}"
}

cool_time
