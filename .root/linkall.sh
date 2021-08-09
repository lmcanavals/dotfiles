#!/bin/sh
# vim: set ts=2:sw=2:noet:sts=2:

linkall() {
	local dotfiles="/home/$1"
	local config=".config"
	local homefiles=(zshrc)
	local configfiles=(nvim zsh)

	echo "Linking ~ files"
	for file in $homefiles; do
		ln -sf "$dotfiles/.$file" ~/
	done

	mkdir -p ~/$config
	echo "Linking ~/.config files..."
	for file in configfiles; do
		ln -sf "$dotfiles/$config/$file" ~/$config/
	done

	echo "All done."
}
linkall lmcs

