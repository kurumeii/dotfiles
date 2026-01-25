#!/bin/bash

# Use fish shell
echo "Changing default shell to fish..."
if command -v fish &> /dev/null; then 
	chsh -s "$(which fish)"
	echo "fish shell configured!"
	else 
	echo "fish shell not found. Please ensure fish is installed."
fi
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
if command -v fisher &> /dev/null; then 
	echo "Installing fish plugins..."

	fisher install PatrickF1/fzf.fish
	echo "fish plugins installed!"
	else 
	echo "fisher not found. Please ensure fisher is installed."
fi

