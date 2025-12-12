if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx LCLR (cat $XDG_CONFIG_HOME/lmcscolors | string collect)

    if test "$TERM" = linux
        echo -en "\e]P0"(string sub -l 6 -s 2 "$LCLR")
        for i in (seq 1 15)
            set start (math "$i * 8 + 2")
            set color_code (string sub -l 6 -s "$start" "$LCLR")
            set hex_i (printf "%x" "$i")
            echo -en "\e]P$hex_i$color_code"
        end
        clear # for background artifacting
    end

    set -gx EDITOR nvim
    set -gx DIFFPROG 'nvim -d'
    set -gx FZF_DEFAULT_COMMAND 'fd --type f'
    set -gx FZF_CTRL_T_COMMAND 'fd --type d'
    set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
	--highlight-line \
	--info=inline-right \
	--ansi \
	--layout=reverse \
	--border=none \
	--color=bg+:#283457 \
	--color=bg:#16161e \
	--color=border:#27a1b9 \
	--color=fg:#c0caf5 \
	--color=gutter:#16161e \
	--color=header:#ff9e64 \
	--color=hl+:#2ac3de \
	--color=hl:#2ac3de \
	--color=info:#545c7e \
	--color=marker:#ff007c \
	--color=pointer:#ff007c \
	--color=prompt:#2ac3de \
	--color=query:#c0caf5:regular \
	--color=scrollbar:#27a1b9 \
	--color=separator:#ff9e64 \
	--color=spinner:#ff007c"

    localismosh.zsh; and set -gx ISMOSHBRUH yup
    if test "$LCTHEME" = dark
        set -gx BAT_THEME tokyonight_day
    else
        set -gx BAT_THEME tokyonight_night
    end

    fish_vi_key_bindings
    starship init fish | source
    fzf --fish | source
end

# vim: set ts=4 sw=4 et sts=4:
