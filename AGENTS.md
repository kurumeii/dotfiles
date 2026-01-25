# AGENTS.md - Chezmoi Dotfiles Repository Guide

## Overview
This is a personal chezmoi dotfiles repository managing configuration files across multiple machines. The primary codebase consists of Lua-based Neovim configuration, shell scripts, and various configuration files for Wayland desktop environment.

## Build/Lint/Test Commands

### Chezmoi Commands
```bash
# Apply changes to system
chezmoi apply

# Preview changes
chezmoi diff
chezmoi apply --dry-run

# Check repository health
chezmoi doctor
chezmoi verify

# Git operations (in source directory)
chezmoi git -- status
chezmoi git -- add .
chezmoi git -- commit -m "message"
chezmoi git -- push
```

### Lua/Neovim Commands
```bash
# Format all Lua files (from nvim directory)
stylua .

# Format specific file
stylua <file>

# Test Neovim configuration
nvim --headless -c "lua print('Config loaded successfully')" -c "qa"

# Check for syntax errors
nvim --headless -c "lua vim.diagnostic.setloclist()" -c "qa"
```

### Shell Commands
```bash
# Test shell scripts
bash -n <script>.sh  # Syntax check
shellcheck <script>.sh  # Lint if available

# Validate configuration files
yamllint <file>.yml
jq . <file>.json
```

## Code Style Guidelines

### Lua Code (Neovim Configuration)
- **Formatting**: Use stylua with project config (tabs, 120 char width, double quotes)
- **Indentation**: Tabs (width: 2 spaces equivalent)
- **Line Length**: 120 characters maximum
- **Variable Naming**: `snake_case` for variables and functions
- **Global Config**: Use `vim.g` namespace (e.g., `vim.g.mapleader`)
- **Options**: Use `vim.o` for setting options (not `vim.opt`)
- **Module Structure**: Place modules in `lua/config/` and `lua/plugins/`

#### Import Patterns
```lua
-- Prefer local variables for modules
local utils = require("config.utils")

-- Use mini.deps for plugin management
now("plugin/name")      -- Immediate load
later("plugin/name")    -- Deferred load
```

#### Function Documentation
Use LuaLS annotations:
```lua
---@param msg string Message to display
---@param level? 'ERROR'|'WARN'|'INFO' Log level
---@param title? string Notification title
H.notify = function(msg, level, title)
```

### Shell Scripts
- **Style**: POSIX-compliant bash/zsh
- **Shebang**: Use `#!/bin/bash` or `#!/bin/zsh` for executable scripts
- **Variables**: Export environment variables explicitly
- **Error Handling**: Use `set -euo pipefail` where appropriate

### Configuration Files
- **JSON**: Validate with `jq .`
- **YAML**: Validate with `yamllint` if available
- **TOML**: Check syntax manually
- **KDL**: Use `niri validate` for niri configuration

## Naming Conventions

### File Naming (Chezmoi)
- `dot_` prefix → hidden files (e.g., `dot_bashrc`)
- `executable_` prefix → executable files
- `.tmpl` suffix → template files
- `private_` prefix → restricted permission files

### Directories
- `dot_config/` → XDG config directory
- `bin/` → executable scripts
- `lua/config/` → core Neovim configuration
- `lua/plugins/` → plugin configurations
- `after/` → post-load customizations

## Error Handling

### Lua
```lua
-- Use pcall for safe operations
local success, result = pcall(function()
  return potentially_failing_operation()
end)
if not success then
  utils.notify(result, "ERROR")
end

-- Validate function arguments
if type(input) ~= "string" then
  error("Expected string input")
end
```

### Shell
```bash
# Exit on errors
set -euo pipefail

# Check command success
if ! command -v some_tool &> /dev/null; then
  echo "some_tool not found" >&2
  exit 1
fi
```

## Testing Workflow

### Before Committing
1. **Format Lua code**: `stylua .`
2. **Check syntax**: Open files in nvim and verify no errors
3. **Test chezmoi changes**: `chezmoi apply --dry-run`
4. **Validate configs**: Format-specific validation
5. **Run health check**: `chezmoi doctor`

### Single Test Commands
```bash
# Test specific Neovim plugin config
nvim --headless -c "lua require('plugins/plugin_name')" -c "qa"

# Test specific shell script
bash -n scripts/script_name.sh

# Test template rendering
chezmoi cat dot_template_file.tmpl
```

## Security Considerations

### Secrets Management
- Never commit plain text secrets
- Use chezmoi templates with KeePassXC: `{{ (keepassxc "path").Password }}`
- Template files end with `.tmpl` extension
- Test template execution before applying

### Permissions
- Executable files use `executable_` prefix
- Sensitive files use `private_` prefix
- Check permissions with `chezmoi managed`

## Common Patterns

### Plugin Configuration
```lua
return {
  "plugin/name",
  version = "*",
  config = function()
    -- Plugin setup
  end,
}
```

### Autocommands
```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function(args)
    -- Custom logic
  end,
})
```

### Key Mappings
```lua
utils.map("n", "<leader>wd", function()
  vim.cmd("close")
end, "Close window")
```

## Tools Integration

### Neovim Plugins
- **mini.nvim**: Primary plugin ecosystem
- **Treesitter**: Syntax highlighting
- **LSPconfig**: Language server protocol
- **Conform.nvim**: Code formatting
- **Blink.cmp**: Completion engine

### External Tools
- **chezmoi**: Dotfiles management
- **KeePassXC**: Secret management
- **stylua**: Lua formatting
- **GitHub CLI**: Git operations

## Debugging

### Neovim Issues
```lua
-- Check for errors
:lua print(vim.inspect(some_variable))

-- Reload configuration
:lua dofile(vim.fn.expand("~/.config/nvim/init.lua"))

-- LSP diagnostics
:lua vim.diagnostic.setloclist()
```

### Chezmoi Issues
```bash
# Debug template data
chezmoi data

# Check managed files
chezmoi managed

# Verbose apply
chezmoi apply --verbose
```

Remember: This is a personal dotfiles repository. Changes should be tested thoroughly before committing as they affect system configuration directly.