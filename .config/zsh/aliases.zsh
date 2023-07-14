#!/usr/bin/zsh

declare -A abk
setopt extendedglob
setopt interactivecomments
abk=(
	"..." "../.."
	"BG"  "& exit"
	"C"   "| wc -l"
	"G"   "|& rg "
	"H"   "| head"
	"Hl"  " --help |& less -r"
	"L"   "| less"
	"LL"  "|& less -r"
	"M"   "| most"
	"N"   "&>/dev/null"
	"R"   "| tr A-z N-za-m"
	"SL"  "| sort | less"
	"S"   "| sort -u"
	"T"   "| tail"
	"V"   "|& nvim -"
	"co"  "./configure && make && sudo make install"
	"j"   "| jq"
	"n"   " nvim "
	"qd"  " pacman -Qdt"
	"qe"  " pacman -Qet"
	"qi"  " pacman -Qi "
	"ql"  " pacman -Ql "
	"qm"  " pacman -Qm"
	"qo"  " pacman -Qo "
	"qs"  " pacman -Qs "
	"rs"  "sudo pacman -Rncs "
	"s"   "sudo pacman -S "
	"sc"  " sudo pacman -Sc"
	"si"  " pacman -Si "
	"ss"  " pacman -Ss "
	"sy"  "sudo pacman -Syu"
	"x"   "| xsel -ib"
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

alias ...="cd ../../"
alias exa="exa -F --icons --colour=auto --group-directories-first "
alias ea="exa -la "
alias eaa="exa -a .*(.)"
alias ead="exa -d .*(/)"
alias ebig="exa -l *(.OL[1,10])"
alias ee="exa -lb "
alias eed="exa -d *(/)"
alias eee="exa -d *(/^F)"
alias enew="exa -rtl *(D.om[1,10])"
alias enewdir="exa -rtdl *(/om[1,10]) .*(D/om[1,10])"
alias eold="exa -rtl *(D.Om[1,10])"
alias eolddir="exa -rtdl *(/Om[1,10]) .*(D/Om[1,10])"
alias esmall="exa -rl *(.oL[1,10])"
alias da="du -sch"
alias diff="diff --color=auto "
alias dotfiles="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME "
alias grep="grep --color=auto "
alias j="jobs -l"
alias ls="ls -b -CF --color=auto --group-directories-first "
alias dir="ls -lSrah"
alias la="ls -la "
alias lad="ls -d .*(/)"
alias lh="ls -hAl "
alias ll="ls -l "
alias lsa="ls -a .*(.)"
alias lsbig="ls -flh *(.OL[1,10])"
alias lsd="ls -d *(/)"
alias lse="ls -d *(/^F)"
alias lsl="ls -l *(@)"
alias lsnew="ls -rtlh *(D.om[1,10])"
alias lsnewdir="ls -rthdl *(/om[1,10]) .*(D/om[1,10])"
alias lsold="ls -rtlh *(D.Om[1,10])"
alias lsolddir="ls -rthdl *(/Om[1,10]) .*(D/Om[1,10])"
alias lss="ls -l *(s,S,t)"
alias lssmall="ls -Srl *(.oL[1,10])"
alias lsw="ls -ld *(R,W,X.^ND/)"
alias lsx="ls -l *(*)"
alias mdstat="bat /proc/mdstat"
alias rmcdir="cd ..; rmdir $OLDPWD || cd $OLDPWD"

# vim: set ts=2:sw=2:noet:sts=2:
