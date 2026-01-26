#!/bin/bash

# Use fish shell
echo "Changing default shell to fish..."
# 1. Change shell to fish if it's not already
if [ "$SHELL" != "$(which fish)" ]; then
	echo "Changing default shell to fish..."
	chsh -s "$(which fish)"
	echo "fish shell configured!"
fi
if command -v fish &>/dev/null; then
	echo "Installing fish plugins..."
	fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source"
	fish -c "fisher install jorgebucaran/fisher"
	fish -c "fisher install PatrickF1/fzf.fish"
	fish -c "fisher install jhillyerd/plugin-git"
fi
