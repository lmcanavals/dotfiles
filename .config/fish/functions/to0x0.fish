function to0x0 --description 'Curl files to 0x0.st'
    echo "Sending $argv[1] to https://0x0.st if all goes well you'll get a url bellow"
    curl -A "lmcsPersonalUse/1.0" -F"file=@$argv[1]" -Fexpires=1 https://0x0.st
end

# vim: set ts=4 sw=4 et sts=4:
