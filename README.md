# Chezmoi Dotfiles

A personal dotfiles management repository using chezmoi to maintain consistent configuration across multiple machines. Supported by AGENTS

## Overview

This repository manages personal configuration files (dotfiles) including:
- Shell environments (bash, zsh) with Oh My Zsh and custom aliases
- Neovim editor with Lua-based configuration and mini.nvim plugins
- Wayland desktop environment (Niri window manager, Waybar, Mako notifications)
- Terminal emulator (Wezterm) and modern CLI tools
- Development tool version management with mise

## Key Features

- ✅ **Secret Management**: Secure handling of API keys and sensitive data via KeePassXC
- ✅ **Modular Neovim**: Lazy-loaded plugins and organized Lua configuration
- ✅ **Modern CLI**: Enhanced shell experience with fzf, eza, bat, ripgrep, and zoxide
- ✅ **Cross-Machine**: Consistent configuration across different environments
- ✅ **Git Integration**: GitHub CLI integration and custom git configuration
- ✅ **Wayland Support**: Full Wayland-based desktop environment setup

## Installation

### Prerequisites
- chezmoi v2.69.3+
- KeePassXC (for secret management)
- Git with GitHub CLI
- Wayland-compatible system

### Setup

1. Install chezmoi:
   ```bash
   sudo dnf install chezmoi -y
   ```

2. Clone and apply dotfiles:
   ```bash
   chezmoi init --apply kurumeii
   ```

3. Set up KeePassXC:
   - Install KeePassXC
   - Create database with required entries for any `.tmpl` files
   - Configure chezmoi to use KeePassXC

## Usage

## Configuration Structure

```
dot_config/
├── nvim/           # Neovim configuration (Lua)
├── niri/           # Window compositor (KDL)
├── waybar/         # Status bar (JSON/CSS)
├── wezterm/        # Terminal (Lua)
├── mako/           # Notifications
├── fuzzel/         # Application launcher
├── btop/           # System monitor
├── lazygit/        # Git TUI
├── yazi/           # File manager
└── mise/           # Version manager
```

## Key Components

### Shell Configuration
- **Oh My Zsh** with custom plugins and themes
- **Modern aliases**: `ls`→`eza`, `cat`→`bat`, `grep`→`rg`
- **Zoxide integration** for smart directory navigation
- **Environment variables** managed via templates

### Neovim Setup
- **Mini.nvim ecosystem** for lightweight, feature-rich configuration
- **LSP integration** with Treesitter syntax highlighting
- **Code formatting** with Conform.nvim
- **Fuzzy finding** and completion with Blink.cmp
- **Lua modules** organized by functionality

### Desktop Environment
- **Niri** Wayland compositor with custom keybindings
- **Waybar** status bar with custom modules
- **Mako** notification daemon
- **Fuzzel** application launcher

### Adding New Tools
1. Add configuration to appropriate `dot_config/` subdirectory
2. Use `chezmoi add` to track new files
3. Test with `chezmoi apply --dry-run`
4. Commit changes with descriptive message

## Troubleshooting

### Common Issues
- **Template errors**: Check KeePassXC database entries
- **Permission issues**: Ensure executable files have `executable_` prefix
- **Path conflicts**: Verify file naming conventions

## License

MIT License - see LICENSE file for details

## Acknowledgments

- [chezmoi](https://chezmoi.io/) for excellent dotfiles management
- [mini.nvim](https://github.com/echasnovski/mini.nvim) for lightweight Neovim plugins
- [Niri](https://github.com/YaLTeR/niri) for innovative Wayland compositor
- The open-source community for all tools used in this setup
