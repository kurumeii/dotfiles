#!/bin/bash

bash "${CHEZMOI_SOURCE_DIR}/import_dnf_plugins.sh"

# Activeate mise
if command -v mise &> /dev/null; then
		echo "Activating mise..."
		mise install -y
		echo "mise activated successfully!"
else
		echo "mise command not found. Please ensure mise is installed."
fi

# Use oh-my-posh to install fonts
if command -v oh-my-posh &> /dev/null; then
		echo "Installing oh-my-posh fonts..."
		for font in "${FONTS[@]}"; do
        echo "Installing font: $font"
        oh-my-posh font install "$font"
    done
		echo "oh-my-posh fonts installed successfully!"
else
		echo "oh-my-posh command not found. Please ensure oh-my-posh is installed."
fi
