#!/usr/bin/zsh

if [[ "$TERM" == "linux" ]]; then
	# echo -en "\e]P0${LCLR:1:6}" && clear # for background artifacting
	for i in {1..15}; do
		echo -en "\e]P$(printf "%x" "$i")${LCLR:$i * 8 + 1:6}"
	done
fi

setopt auto_cd
setopt auto_pushd
setopt cdable_vars
setopt pushd_ignore_dups

setopt complete_in_word
setopt hash_list_all

setopt extended_glob
setopt no_globdots
setopt no_no_match
setopt unset

setopt append_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history

setopt long_list_jobs
setopt no_hup
setopt notify

setopt no_sh_word_split

setopt no_beep

watch=(notme root)

typeset -U PATH path cdpath fpath manpath

bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
bindkey -M vicmd "$terminfo[kend]"  vi-end-of-line
bindkey -M viins "$terminfo[kdch1]" vi-delete-char
bindkey -M viins "$terminfo[cuu1]"  vi-up-line-or-history
bindkey -M viins "$terminfo[cuf1]"  vi-forward-char
bindkey -M viins "$terminfo[kcuu1]" vi-up-line-or-history
bindkey -M viins "$terminfo[kcud1]" vi-down-line-or-history
bindkey -M viins "$terminfo[kcuf1]" vi-forward-char
bindkey -M viins "$terminfo[kcub1]" vi-backward-char

bindkey -v

## beginning-of-line OR beginning-of-buffer OR beginning of history
## by: Bart Schaefer <schaefer@brasslantern.com>, Bernhard Tittelbach
beginning-or-end-of-somewhere() {
	local hno=$HISTNO
	if [[ ( "${LBUFFER[-1]}" == $'\n' && "$WIDGET" == beginning-of* ) || \
				( "${RBUFFER[1]}" == $'\n' && "$WIDGET" == end-of* ) ]]; then
		zle .${WIDGET:s/somewhere/buffer-or-history/} "$@"
	else
		zle .${WIDGET:s/somewhere/line-hist/} "$@"
		if (( HISTNO != hno )); then
			zle .${WIDGET:s/somewhere/buffer-or-history/} "$@"
		fi
	fi
}
zle -N beginning-of-somewhere beginning-or-end-of-somewhere
zle -N end-of-somewhere beginning-or-end-of-somewhere

bindkey "\eOH" beginning-of-somewhere    # 
bindkey "\e[H" beginning-of-somewhere    # 
bindkey "\eOF" end-of-somewhere          # end
bindkey "\e[F" end-of-somewhere          # end
if [[ "$TERM" == "linux" ]]; then
	bindkey "\e[1~" beginning-of-somewhere # 
	bindkey "\e[4~" end-of-somewhere       # end
fi

bindkey "\e[A"  up-line-or-search        # ↑
bindkey "\e[B"  down-line-or-search      # esc

bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[1;3C" forward-word
bindkey "\e[1;3D" backward-word

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
bindkey "^xp"   history-beginning-search-backward-end
bindkey "^xP"   history-beginning-search-forward-end
bindkey "\e[5~" history-beginning-search-backward-end # Pg↑
bindkey "\e[6~" history-beginning-search-forward-end  # Pg↓

#autoload -U insert-unicode-char
#zle -N insert-unicode-char
#bindkey "^xi" insert-unicode-char

bindkey "$terminfo[kcbt]" reverse-menu-complete

commit-to-history() {
	print -s ${(z)BUFFER}
	zle send-break
}
zle -N commit-to-history
bindkey "^x^h" commit-to-history

# only slash should be considered as a word separator:
slash-backward-kill-word() {
	local WORDCHARS="${WORDCHARS:s@/@}"
	zle backward-kill-word
}
zle -N slash-backward-kill-word

bindkey "\ev"  slash-backward-kill-word
bindkey "\e^?" slash-backward-kill-word
bindkey "\e^h" slash-backward-kill-word
bindkey "^H"   slash-backward-kill-word

bindkey "^r" history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

autoload -U zmv
autoload -U history-search-end

autoload -U url-quote-magic && zle -N self-insert url-quote-magic

alias run-help >&/dev/null && unalias run-help
autoload -U run-help
autoload -U run-help-git

autoload -U compinit && compinit
autoload -U zed

for mod in complist deltochar mathfunc; do
	zmodload -i zsh/$mod 2>/dev/null
done

zmodload -a  zsh/stat    zstat
zmodload -a  zsh/zpty    zpty
zmodload -ap zsh/mapfile mapfile

autoload -U insert-files && zle -N insert-files && bindkey "^xf" insert-files

bindkey " "   magic-space
bindkey "\ei" menu-complete

autoload -U edit-command-line && zle -N edit-command-line \
	&& bindkey "\ee" edit-command-line

if [[ -n ${(k)modules[zsh/complist]} ]]; then
	bindkey -M menuselect "\e^M" accept-and-menu-complete
	bindkey -M menuselect "+" accept-and-menu-complete
	bindkey -M menuselect "^[[2~" accept-and-menu-complete
	bindkey -M menuselect "^o" accept-and-infer-next-history
fi

insert-datestamp() { LBUFFER+=${(%):-"%D{%Y-%m-%d}"}; }
zle -N insert-datestamp
bindkey "^ed" insert-datestamp

insert-last-typed-word() { zle insert-last-word -- 0 -1 };
zle -N insert-last-typed-word;
bindkey "\em" insert-last-typed-word

function grml-zsh-fg() {
	if (( ${#jobstates} )); then
		zle .push-input
		[[ -o hist_ignore_space ]] && BUFFER=" " || BUFFER=""
		BUFFER="${BUFFER}fg"
		zle .accept-line
	else
		zle -M "No background jobs. Doing nothing."
	fi
}
zle -N grml-zsh-fg
bindkey "^z" grml-zsh-fg

function jump_after_first_word() {
	local words
	words=(${(z)BUFFER})
	if (( ${#words} <= 1 )); then
		CURSOR=${#BUFFER}
	else
		CURSOR=${#${words[1]}}
	fi
}
zle -N jump_after_first_word
bindkey "^x1" jump_after_first_word

zle -C hist-complete complete-word _generic
zstyle ":completion:hist-complete:*" completer _history
bindkey "^x^x" hist-complete

DIRSTACKSIZE=${DIRSTACKSIZE:-20}
DIRSTACKFILE=${DIRSTACKFILE:-$HOME/.zdirs}
if [[ -f $DIRSTACKFILE ]] && [[ ${#dirstack[*]} -eq 0 ]]; then
	dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
	[[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi

chpwd() {
	local -ax my_stack
	my_stack=( $PWD $dirstack )
	builtin print -l ${(u)my_stack} >! $DIRSTACKFILE
}

function chpwd_profiles() {
	local profile context
	local -i reexecute

	context=":chpwd:profiles:$PWD"
	zstyle -s "$context" profile profile || profile="default"
	zstyle -T "$context" re-execute && reexecute=1 || reexecute=0
	if (( ${+parameters[CHPWD_PROFILE]} == 0 )); then
		typeset -g CHPWD_PROFILE
		local CHPWD_PROFILES_INIT=1
		(( ${+functions[chpwd_profiles_init]} )) && chpwd_profiles_init
	elif [[ $profile != $CHPWD_PROFILE ]]; then
		(( ${+functions[chpwd_leave_profile_$CHPWD_PROFILE]} )) \
			&& chpwd_leave_profile_$CHPWD_PROFILE
	fi
	if (( reexecute )) || [[ $profile != $CHPWD_PROFILE ]]; then
		(( ${+functions[chpwd_profile_$profile]} )) && chpwd_profile_$profile
	fi
	CHPWD_PROFILE="$profile"
	return 0
}

chpwd_functions=( $chpwd_functions chpwd_profiles )

#setopt transient_rprompt
autoload -U colors && colors
function left_prompt() {
	local c
	local s
	[[ EUID -eq 0 ]] && c="red" || c="green"
	if [[ $KEYMAP == vicmd ]]; then
		s="␛"
		c="yellow"
	else
		s="␁"
	fi
	print "%{$bg[$c]$fg[black]%}$s%#%{$reset_color$fg[$c]%}▖%{$reset_color%}"
}
eval "$(starship init zsh)"
RPROMPT=$PROMPT
PROMPT="$(left_prompt)"
PS2='%{$bg[blue]%}%_%{$reset_color$fg[blue]%}▖%{$reset_color%}'
PS3='%{$bg[blue]%}?#%{$reset_color$fg[blue]%}▖%{$reset_color%}'
PS4='%{$bg[blue]%}+%N:%i:%_%{$reset_color$fg[blue]%}▖%{$reset_color%}'

function info_print() {
	local esc_begin esc_end
	esc_begin="$1"
	esc_end="$2"
	shift 2
	printf "%s" "$esc_begin"
	printf "%s" "$*"
	printf "%s" "$esc_end"
}

function set_title() {
	case $TERM in
		(xterm*|rxvt*)
			info_print  $'\e]0;' $'\a' "$@"
			;;
	esac
}

zle-keymap-select() {
	PROMPT="$(left_prompt)"
	() { return $__prompt_status }
	zle reset-prompt
}

zle-line-init() {
	typeset -g __prompt_status="$?"
}

zle -N zle-keymap-select
zle -N zle-line-init

precmd() {
	ZLE_RPROMPT_INDENT=0 # not buggy anymore
	PROMPT="$(left_prompt)"
	set_title ${(%):-"%n@%m %~"}
}

preexec() {
	set_title "${(%):-"%n@%m"}" "$1"
}

# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit -s

zstyle ":completion:*:approximate:"    max-errors \
       "reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )"
zstyle ":completion:*:correct:*"       insert-unambiguous true
zstyle ":completion:*:corrections"     format "%{$fg9%}%d, errors: %e%{$vend%}"
zstyle ":completion:*:correct:*"       original true
zstyle ":completion:*:default"         list-colors ${(s.:.)LS_COLORS}
zstyle ":completion:*:descriptions"    format "%{$fgb%}%d%{$vend%}"
zstyle ":completion:*:expand:*"        tag-order all-expansions
zstyle ":completion:*:history-words"   list false
zstyle ":completion:*:history-words"   menu yes
zstyle ":completion:*:history-words"   remove-all-dups yes
zstyle ":completion:*:history-words"   stop yes
zstyle ":completion:*"                 matcher-list "m:{a-z}={A-Z}"
zstyle ":completion:*:matches"         group "yes"
zstyle ":completion:*"                 group-name ""
zstyle ":completion:*"                 menu select=5
zstyle ":completion:*:messages"        format "%{$fgd%}%d%{$vend%}"
zstyle ":completion:*:options"         auto-description "%{$fga%}%d%{$vend%}"
zstyle ":completion:*:options"         description "yes"
zstyle ":completion:*:processes"       command "ps -au$USER"
zstyle ":completion:*:*:-subscript-:*" tag-order indexes parameters
zstyle ":completion:*"                 verbose true
zstyle ":completion:*:-command-:*:"    verbose false
zstyle ":completion:*:warnings"        format "%{$fg9%}No matches:%{$vend%} %d"
zstyle ":completion:*:*:zcompile:*"    ignored-patterns "(*~|*.zwc)"
zstyle ":completion:correct:"          prompt "correct to: %e"
zstyle ":completion::(^approximate*):*:functions" ignored-patterns "_*"
zstyle ":completion:*:processes-names" command "ps c -u $USER -o command|uniq"
zstyle ":completion:*:manuals"         separate-sections true
zstyle ":completion:*:manuals.*"       insert-sections true
zstyle ":completion:*:man:*"           menu yes select
zstyle ":completion:*"                 special-dirs ..

# run rehash on completion so new installed program are found automatically:
_force_rehash() {
	(( CURRENT == 1 )) && rehash
	return 1
}

setopt correct
zstyle -e ":completion:*" completer '
if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]]; then
	_last_try="$HISTNO$BUFFER$CURSOR"
	reply=(_complete _match _ignored _prefix _files)
elif [[ $words[1] == (rm|mv) ]]; then
	reply=(_complete _files)
else
	reply=(_oldlist _expand _force_rehash _complete \
				 _ignored _correct _approximate _files)
fi'

[[ -d $ZDOTDIR/cache ]] && \
	zstyle ":completion:*"           use-cache yes && \
	zstyle ":completion::complete:*" cache-path $ZDOTDIR/cache/

# vim: se ts=2:sw=2:noet:sts=2
