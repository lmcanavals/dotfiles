# XDG essentials
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME "$HOME/.config"
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME "$HOME/.local/share"
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME "$HOME/.cache"
set -q XDG_STATE_HOME; or set -gx XDG_STATE_HOME "$HOME/.local/state"

# Clang stuff
set -gx CC /usr/bin/clang
set -gx CXX '/usr/bin/clang++'

# Go stuff
set -gx GOPATH "$XDG_DATA_HOME/go"
if not test -d "$GOPATH/bin"
    mkdir -p "$GOPATH/bin"
end
fish_add_path "$GOPATH/bin"

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

# opencode
fish_add_path /home/lmcs/.opencode/bin

# Local bin
if test -d "$HOME/.local/bin"
    fish_add_path "$HOME/.local/bin"
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx LCLR (cat ~/.config/lmcscolors | string collect)

    set -gx EDITOR nvim
    set -gx DIFFPROG 'nvim -d'
    set -gx FZF_DEFAULT_COMMAND 'fd --type f'
    set -gx FZF_CTRL_T_COMMAND 'fd --type d'

    lismosh; and set -gx ISMOSHBRUH yup
    set --global fish_key_bindings fish_vi_key_bindings
    starship init fish | source
    fzf --fish | source
end

# vim: set ts=4 sw=4 et sts=4:
