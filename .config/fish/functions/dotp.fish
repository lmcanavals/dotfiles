function dotp --description 'Exports GIT_DIR and GIT_WORK_TREE for the current session'
    set -gx GIT_DIR "$HOME/.dotfiles.git"
    set -gx GIT_WORK_TREE "$HOME"
    echo "Ok now we can see the dotfiles repo"
end
