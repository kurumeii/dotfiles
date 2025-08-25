#!/bin/bash

# This script handles the initial setup of a new machine.
# It's named to run on-change and after other files are applied.

# Exit immediately if a command exits with a non-zero status.
set -e

echo "››››››››››››››››››››››››››››››››››››››››››››››››››"
echo "                        BOOTSTRAPPING MACHINE"
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

# --- Gum ---
if ! command -v gum &>/dev/null; then
  brew install gum
fi

# Now that gum is installed, we can use it for the rest of the script.

gum style --border thick --margin "1" --padding "1" --border-foreground 212 "››››››››››››››››››››››››››››››››››››››››››››››››››"
gum style --bold --foreground 212 "                        STYLISH BOOTSTRAPPING"
gum style --border thick --margin "1" --padding "1" --border-foreground 212 "››››››››››››››››››››››››››››››››››››››››››››››››››"

gum style --border normal --margin "1" --padding "1" --border-foreground 212 "--- Homebrew Bundle ---"
gum spin --spinner dot --title "Updating Homebrew and running Brewfile..." -- brew bundle

# --- Rust ---
gum style --border normal --margin "1" --padding "1" --border-foreground 212 "--- Rust ---"
echo "Checking Rust..."
if ! command -v rustup &>/dev/null; then
  gum spin --spinner dot --title "Rustup not found. Installing..." -- rustup-init -y
else
  gum style --foreground "0" --background "2" --padding "0 1" "Rust already installed."
fi

# --- Zsh ---
gum style --border normal --margin "1" --padding "1" --border-foreground 212 "--- Zsh ---"
echo "Checking Zsh..."
if ! command -v zsh &>/dev/null; then
  gum spin --spinner dot --title "Zsh not found. Installing..." -- sudo apt update && sudo apt install zsh -y || sudo dnf install zsh -y
else
  gum style --foreground "0" --background "2" --padding "0 1" "Zsh already installed."
fi

# --- Zsh lugin ---
if command -v zsh &>/dev/null; then
  gum style --border normal --margin "1" --padding "1" --border-foreground 212 "--- Zsh Plugins ---"
  # --- Oh My Zsh ---
  echo "Checking for oh-my-zsh..."
  if [ -d "$HOME/.oh-my-zsh" ]; then
    gum spin --spinner dot --title "oh-my-zsh found. Pulling latest changes..." -- git -C "$HOME/.oh-my-zsh" pull
  else
    gum spin --spinner dot --title "oh-my-zsh not found. Installing..." -- sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  # -- fzf-tab plugin ---
  echo "Checking for fzf-tab plugin..."
  # Define the target directory
  ZSH_CUSTOM_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
  FZF_TAB_DIR="$ZSH_CUSTOM_DIR/plugins/fzf-tab"

  if [ ! -d "$FZF_TAB_DIR" ]; then
    gum spin --spinner dot --title "fzf-tab not found. Cloning..." -- git clone https://github.com/Aloxaf/fzf-tab "$FZF_TAB_DIR"
  else
    gum style --foreground "0" --background "2" --padding "0 1" "fzf-tab already installed."
  fi
else
  gum style --foreground "3" --padding "0 1" "Skipping Zsh plugin installation because zsh is not installed."
fi

# Node package mangager
gum style --border normal --margin "1" --padding "1" --border-foreground 212 "--- Node.js ---"
if command -v fnm &>/dev/null; then
  gum spin --spinner dot --title "fnm found. Installing latest LTS Node.js..." -- fnm install --lts --corepack-enabled
else
  gum style --foreground "3" --padding "0 1" "Skipping Node.js installation because fnm is not installed."
fi

gum style --border double --margin "1" --padding "1" --border-foreground 212 "››››››››››››››››››››››››››››››››››››››››››››››››››"
gum style --bold --foreground 212 "                        BOOTSTRAP COMPLETE"
gum style --border double --margin "1" --padding "1" --border-foreground 212 "››››››››››››››››››››››››››››››››››››››››››››››››››"

