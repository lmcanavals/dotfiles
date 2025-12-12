function fish_greeting --description 'The fish greeting'
    if test "$TERM" != linux
        chafa .face
    else
        echo "Come fishy fishy fishy! ><O>"
    end
end

# vim: set ts=4 sw=4 et sts=4:
