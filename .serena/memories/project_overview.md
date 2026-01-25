# Project Overview

## Purpose
This is a **chezmoi dotfiles management repository** that manages personal configuration files (dotfiles) across multiple machines. The repository contains configuration for:
- Shell environments (bash, zsh)
- Neovim editor configuration (Lua-based with mini.nvim)
- Window manager/desktop environment (Niri, Waybar, Mako)
- Terminal emulator (Wezterm)
- Various CLI tools (btop, lazygit, yazi, fuzzel, mise, rclone, etc.)

## Tech Stack
- **Dotfiles Management**: chezmoi v2.69.3
- **Neovim Configuration**: Lua with mini.nvim plugin framework
- **Shell**: Zsh (primary) with Oh My Zsh, Bash (fallback)
- **Version Control**: Git with GitHub CLI integration
- **Templating**: Chezmoi templates with KeePassXC secret integration
- **Formatting**: stylua for Lua code

## Key Features
- Secret management using KeePassXC integration (e.g., API keys in .zshenv.tmpl)
- Modular Neovim configuration using mini.deps for lazy loading
- Shell enhancements: zoxide, fzf, eza, bat, ripgrep
- Oh My Posh prompt customization (andrew.omp.json)
- Wayland-based window management (Niri compositor)
