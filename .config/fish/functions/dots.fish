function dots --wraps='git --git-dir=/home/lmcs/.dotfiles.git --work-tree=/home/lmcs' --description 'alias dots=git --git-dir=/home/lmcs/.dotfiles.git --work-tree=/home/lmcs'
    git --git-dir=/home/lmcs/.dotfiles.git --work-tree=/home/lmcs $argv
end
