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
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  echo "Homebrew already installed."
fi

echo "Updating Homebrew and running Brewfile..."
brew bundle

# --- Rust ---
echo "Checking Rust..."
if ! command -v rustup &>/dev/null; then
  echo "Rustup not found. Installing..."
  rustup-init -y
else
  echo "Rust already installed."
fi

# --- Zsh ---
echo "Checking Zsh..."
if ! command -v zsh &>/dev/null; then
  echo "Zsh not found. Installing..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt &>/dev/null; then
      sudo apt update
      sudo apt install zsh -y
    elif command -v dnf &>/dev/null; then
      sudo dnf install zsh -y
    else
      echo "Could not find apt or dnf. Please install zsh manually."
      exit 1
    fi
  else
    echo "Unsupported OS for automatic zsh installation"
  fi
else
  echo "Zsh already installed."
fi

# --- Zsh fzf-tab plugin ---
if command -v zsh &>/dev/null; then
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
else
    echo "Skipping fzf-tab installation because zsh is not installed."
fi

echo "››››››››››››››››››››››››››››››››››››››››››››››››››"
echo "                        BOOTSTRAP COMPLETE"
echo "››››››››››››››››››››››››››››››››››››››››››››››››››"
echo "››››››››››››››››››››››››››››››››››››››››››››››››››"
