#!/bin/bash
# Script to enable COPR repositories on a fresh Fedora installation

set -e  # Exit on error

echo "Enabling COPR repositories..."

# List of COPR repositories to enable
COPR_REPOS=(
	"avengemedia/dms"
	"jdxcode/mise"
	"terjeros/eza"
	"wezfurlong/wezterm-nightly"
)

# Loop through and enable each COPR repo
for repo in "${COPR_REPOS[@]}"; do
	echo "Enabling COPR: $repo"
	sudo dnf copr enable -y "$repo"
done

echo "All COPR repositories enabled successfully!"

echo ""
echo "Installing essential packages..."

# List of packages to install
PACKAGES=(
	"fish"
	"wezterm"
	"eza"
	"niri"
	"dms"
	"mise"
	"tldr"
	"swaybg"
	"usbutils"
	"rclone"
	"neovim"
	"mako"
	"waybar"
	"lynx"
	"git"
	"gcc"
	"make"
	"ghostscript"
	"keepassxc"
	"snapshot"
	"blueman-manager"
	"fcitx5"
	"fcitx5-qt5"
	"fcitx5-unikey"
	"gnome-text-editor"
	"nautilus"
)
# Install packages
sudo dnf install -y "${PACKAGES[@]}"
echo "All packages installed successfully!"
