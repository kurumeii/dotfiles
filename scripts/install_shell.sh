#!/bin/bash

# Use fish shell
echo "Changing default shell to fish..."
if command -v fish &>/dev/null; then
	chsh -s "$(which fish)"
	echo "fish shell configured!"
	fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher install PatrickF1/fzf.fish"
fi
