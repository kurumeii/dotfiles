#!/bin/bash

# Use oh-my-posh to install fonts
if command -v oh-my-posh &> /dev/null; then
		echo "Installing oh-my-posh fonts..."
		FONTS=(
				"CaskaydiaCove Nerd Font"
				"FiraCode Nerd Font"
				"JetBrainsMono Nerd Font"
		)
		for font in "${FONTS[@]}"; do
        echo "Installing font: $font"
        oh-my-posh font install "$font"
    done
		echo "oh-my-posh fonts installed successfully!"
else
		echo "oh-my-posh command not found. Please ensure oh-my-posh is installed."
fi
