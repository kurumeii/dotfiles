#!/bin/bash

# This script handles the initial setup of a new machine.
# It's named to run on-change and after other files are applied.

# Exit immediately if a command exits with a non-zero status.
set -e

echo "››››››››››››››››››››››››››››››››››››››››››››››››››"
echo "››››››››››››››››››››››››››››››››››››››››››››››››››"
echo "                        BOOTSTRAPPING MACHINE"
echo "››››››››››››››››››››››››››››››››››››››››››››››››››"
echo "››››››››››››››››››››››››››››››››››››››››››››››››››"

# --- Homebrew ---
echo "Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed."
fi

echo "Updating Homebrew and running Brewfile..."
brew update
brew bundle --global

# --- Rust ---
echo "Checking Rust..."
if ! command -v rustup &>/dev/null; then
  echo "Rustup not found. Installing..."
  # The rustup-init script might be installed via the Brewfile.
  # If not, this will fail. Ensure 'rustup-init' is in your Brewfile.
  rustup-init -y
else
  echo "Rust already installed."
fi

# --- Zsh fzf-tab plugin ---
echo "Checking for fzf-tab plugin..."
# Define the target directory
ZSH_CUSTOM_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
FZF_TAB_DIR="$ZSH_CUSTOM_DIR/plugins/fzf-tab"

if [ ! -d "$FZF_TAB_DIR" ]; then
  echo "fzf-tab not found. Cloning..."
  git clone https://github.com/Aloxaf/fzf-tab "$FZF_TAB_DIR"
else
  echo "fzf-tab already installed."
fi

echo "››››››››››››››››››››››››››››››››››››››››››››››››››"
echo "                        BOOTSTRAP COMPLETE"
echo "››››››››››››››››››››››››››››››››››››››››››››››››››"
echo "››››››››››››››››››››››››››››››››››››››››››››››››››"
