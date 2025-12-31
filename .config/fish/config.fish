# Clang stuff
set -gx CC /usr/bin/clang
set -gx CXX '/usr/bin/clang++'

# Go stuff
if test -d /usr/local/go/bin
    fish_add_path $GOPATH_BIN
end

if test -d "$HOME/.local/share/go"
    set -gx GOPATH "$HOME/.local/share/go"
end

# Java stuff
if test -d /opt/java
    set -gx JAVA_HOME /opt/java
    set -gx CLASSPATH "$JAVA_HOME/lib"
    fish_add_path "$JAVA_HOME/bin"
end

# Maven
if test -d /opt/maven
    set -gx M2_HOME /opt/maven
    set -gx M2 "$M2_HOME/bin"
    set -gx MAVEN_OPTS "-Xms256m -Xmx512m"
    fish_add_path $M2
end

# Local bin
if test -d "$HOME/.local/bin"
    fish_add_path "$HOME/.local/bin"
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx LCLR (cat ~/.config/lmcscolors | string collect)

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

    set --global fish_key_bindings fish_vi_key_bindings
    fish_config theme choose "TokyoNight Night"
    starship init fish | source
    fzf --fish | source
end

# vim: set ts=4 sw=4 et sts=4:
