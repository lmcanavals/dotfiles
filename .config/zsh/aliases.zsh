#!/usr/bin/zsh

declare -A abk
setopt extendedglob
setopt interactivecomments
abk=(
	"..."  "../.."
	"...." "../../.."
	"BG"   "& exit"
	"C"    "| wc -l"
	"G"    "|& grep "
	"H"    "| head"
	"Hl"   " --help |& less -r"
	"L"    "| less"
	"LL"   "|& less -r"
	"M"    "| most"
	"N"    "&>/dev/null"
	"R"    "| tr A-z N-za-m"
	"SL"   "| sort | less"
	"S"    "| sort -u"
	"T"    "| tail"
	"V"    "|& nvim -"
	"co"   "./configure && make && sudo make install"
	"syu"  "yay -Syu"
	"ss"   "yay -Ss "
	"si"   "yay -Si "
	"s"    "yay -S "
	"sc"   "yay -Sc"
	"qs"   "yay -Qs "
	"qi"   "yay -Qi "
	"qo"   "yay -Qo "
	"ql"   "yay -Ql "
	"qm"   "yay -Qm"
	"qet"  "yay -Qet"
	"qdt"  "yay -Qdt"
	"rncs" "yay -Rncs "
)

zleiab() {
	emulate -L zsh
	setopt extendedglob
	local MATCH

	if (( NOABBREVIATION > 0 )) ; then
		# LBUFFER="$LBUFFER,."
		LBUFFER="$LBUFFER "
		return 0
	fi

	matched_chars="[.-|_a-zA-Z0-9]#"
	LBUFFER=${LBUFFER%%(#m)[.-|_a-zA-Z0-9]#}
	LBUFFER+=${abk[$MATCH]:-$MATCH}
	_zsh_highlight # workaround to highlight after autocompleting
}
zle -N zleiab && bindkey "^@" zleiab
#zle -N zleiab && bindkey ",." zleiab

alias diff="diff --color=auto "
alias grep="grep --color=auto "
alias ls="ls -b -CF --color=auto --group-directories-first "
alias la="ls -la "
alias ll="ls -l "
alias lh="ls -hAl "
alias l="ls -lF "
alias mdstat="cat /proc/mdstat"
alias ...="cd ../../"
alias da="du -sch"
alias j="jobs -l"
alias dir="ls -lSrah"
alias lad="ls -d .*(/)"
alias lsa="ls -a .*(.)"
alias lss="ls -l *(s,S,t)"
alias lsl="ls -l *(@)"
alias lsx="ls -l *(*)"
alias lsw="ls -ld *(R,W,X.^ND/)"
alias lsbig="ls -flh *(.OL[1,10])"
alias lsd="ls -d *(/)"
alias lse="ls -d *(/^F)"
alias lsnew="ls -rtlh *(D.om[1,10])"
alias lsold="ls -rtlh *(D.Om[1,10])"
alias lssmall="ls -Srl *(.oL[1,10])"
alias lsnewdir="ls -rthdl *(/om[1,10]) .*(D/om[1,10])"
alias lsolddir="ls -rthdl *(/Om[1,10]) .*(D/Om[1,10])"
alias rmcdir="cd ..; rmdir $OLDPWD || cd $OLDPWD"
alias dotfiles="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME "

# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

