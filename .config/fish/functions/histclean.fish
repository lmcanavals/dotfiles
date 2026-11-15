function histclean --description "Interactively select and delete Fish history entries"
    argparse s/sort -- $argv
    or return

    set -l filter_cmd cat
    if set -q _flag_sort
        set filter_cmd sort -z -t '|' -k 2
    end

    set -l selected (
        history search --show-time="%Y-%m-%d %H:%M:%S | " --null | \
        $filter_cmd | \
        fzf --read0 -m --print0 \
            --delimiter=" \| " \
            --with-nth=2.. \
            --preview='echo -e "\e[36mTime:\e[0m {1}\n\e[36mCommand:\e[0m\n{2..}"' \
            --preview-window=down:40%:wrap | \
        string split0
    )

    if test (count $selected) -eq 0
        echo "No items selected."
        return 0
    end

    for entry in $selected
        set -l parts (string split -m 1 " | " -- "$entry")
        set -l cmd_text $parts[2]

        history delete --exact --case-sensitive -- "$cmd_text"
        echo -e "\e[32m✔ Deleted:\e[0m $cmd_text"
    end
end

# vim: set ts=4 sw=4 et sts=4:
