function fish_greeting --description 'The fish greeting'
    if test "$TERM" != linux
        set -l artwork_dir "$XDG_DATA_HOME/artwork/"
        set -l banner "$artwork_dir/archbanner.png"
        set -l url "https://archlinux.org/static/logos/archlinux-logo-light-90dpi.png"
        if not test -f $banner
            mkdir -p "$artwork_dir"
            curl -o "$banner" $url &>/dev/null
            clear
        end
        chafa "$banner"
    else
        cat /etc/motd
    end
end

# vim: set ts=4 sw=4 et sts=4:
