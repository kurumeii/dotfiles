# Suggested Commands

## Chezmoi Commands (Primary Workflow)

### Daily Usage
- `chezmoi add <file>` - Add a file to source state
- `chezmoi edit <file>` - Edit source state of a target file
- `chezmoi apply` - Apply changes to destination directory (update dotfiles)
- `chezmoi diff` - Show differences between source and destination
- `chezmoi status` - Show status of all managed files
- `chezmoi update` - Pull latest changes and apply them

### Advanced Commands
- `chezmoi cd` - Open a shell in the source directory
- `chezmoi git -- <args>` - Run git commands in source directory
- `chezmoi edit-config` - Edit chezmoi configuration
- `chezmoi re-add` - Re-add modified files
- `chezmoi merge-all` - Three-way merge for all modified files
- `chezmoi data` - Print template data

### Template Commands
- `chezmoi cat <file>` - Print target contents after template execution
- `chezmoi execute-template` - Execute template expressions

### Verification
- `chezmoi doctor` - Check system for potential problems
- `chezmoi verify` - Verify destination matches target state
- `chezmoi managed` - List managed files
- `chezmoi unmanaged` - List unmanaged files

## Git Commands
- `chezmoi git -- status` - Check git status in source directory
- `chezmoi git -- add .` - Stage all changes
- `chezmoi git -- commit -m "message"` - Commit changes
- `chezmoi git -- push` - Push to remote repository

## Neovim/Lua Development
- `stylua .` - Format all Lua files (from nvim directory)
- `stylua <file>` - Format specific Lua file
- `nvim` - Open Neovim to test configuration changes

## Shell Commands (Modern Alternatives)
- `eza --long --icons --all --no-user` (alias: `ls`)
- `bat <file>` (alias: `cat`)
- `rg <pattern>` (alias: `grep`)
- `tldr <command>` (alias: `man`)
- `z <path>` (zoxide, alias: `cd`)
- `gh` - GitHub CLI
- `mise` - Development tool version manager

## System Information
- `fastfetch -c examples/8.jsonc` - Display system info
- `btop` - System monitor

## File Management
- `yazi` - Terminal file manager

## Version Control
- `lazygit` - Git TUI (Terminal User Interface)
