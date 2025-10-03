# Agent Guidelines for Neovim Configuration

## Build/Lint/Test Commands

### Formatting & Linting
- **Format code**: `stylua .` (uses stylua.toml config)
- **Spell check**: `cspell .` (uses cspell.config.yaml)
- **Health check**: `:checkhealth` in Neovim

### Plugin Management
- **Update plugins**: `:Lazy update`
- **Sync plugins**: `:Lazy sync`
- **Clean plugins**: `:Lazy clean`

## Code Style Guidelines

### Formatting
- **Indentation**: Tabs with width 2
- **Line length**: 120 characters max
- **Quotes**: Auto-prefer double quotes
- **File format**: Use stylua for consistent formatting

### Lua Conventions
- **Type annotations**: Use EmmyLua style (`---@type`, `---@param`)
- **Global variables**: Use `vim.g.` for configuration
- **Local variables**: Prefer `local` declarations
- **Function naming**: camelCase for utility functions
- **Module structure**: Use `local H = {}` pattern for utilities

### Naming Conventions
- **Files**: lowercase with hyphens (e.g., `keymaps.lua`)
- **Functions**: camelCase (e.g., `hexToHSL`)
- **Variables**: snake_case for locals, camelCase for globals
- **Constants**: UPPER_CASE

### Imports & Dependencies
- **Require pattern**: `local utils = require("utils")`
- **Lazy loading**: Use `event`, `ft`, `cmd` for plugin loading
- **Plugin specs**: Follow lazy.nvim format with `opts` table

### Error Handling
- **Notifications**: Use `H.notify()` or `vim.notify()`
- **Error checking**: Check return values and use `pcall` for safety
- **Graceful degradation**: Handle missing dependencies

### Keymaps
- **Utility wrapper**: Use `utils.map()` for consistent keymaps
- **Descriptions**: Always provide `desc` for which-key integration
- **Buffer local**: Use `buffer` option for file-specific mappings

## Copilot Instructions

This project is a modular Neovim configuration using Lua, structured for maintainability and extensibility. The main entry point is `init.lua`, which bootstraps the plugin manager (`lazy.nvim`) and loads configuration from the `lua/config` and `lua/plugins` directories.

### Architecture & Key Files
- `init.lua`: Bootstraps plugin manager, loads config, sets colorscheme
- `lua/config/`: Core editor settings split into options, keymaps, autocmds, mininvim
- `lua/plugins/`: Each file configures a specific plugin (e.g., LSP, Treesitter, linting)
- `health.lua`: Health checks for Neovim version and required executables
- `utils.lua`: Shared utility functions for mapping keys, notifications, and more

### Developer Workflows
- Plugin Management: Uses lazy.nvim. Plugins are defined in `lua/plugins/` and loaded via `init.lua`
- Configuration Reload: Changes to files in `lua/config/` or `lua/plugins/` require restarting Neovim or re-sourcing the file
- Health Check: Run `:checkhealth` to verify system and plugin requirements
- Keymaps: Custom keymaps are defined in `keymaps.lua` and use utility wrappers for consistency
- Autocommands: Custom autocommands are set in `autocmds.lua`, including LSP attach events and file explorer behaviors

### Project-Specific Patterns
- Modular Config: Each plugin and config aspect is isolated in its own file for clarity and easy extension
- Global Icons: UI glyphs and icons are defined in `mininvim.lua` for consistent visual language across plugins
- Utility-Driven Mapping: Keymaps and autocommands use functions from `utils.lua` to reduce duplication and enforce conventions
- LSP & Diagnostics: LSP-related keymaps and autocommands are grouped and use buffer-local mappings
- Health Checks: `health.lua` provides a template for system validation, not required for config but useful for onboarding

### Integration Points & External Dependencies
- Plugin Manager: `lazy.nvim` (auto-cloned if missing)
- Required Tools: `git`, `make`, `unzip`, `rg` (ripgrep) for plugin installation and searching
- Nerd Font: Set `vim.g.have_nerd_font = true` if using a Nerd Font for icon support

### Example Patterns
- Adding a Plugin: Create a new file in `lua/plugins/` and add its config. Reference it in `init.lua` via the lazy setup import
- Custom Keymap: Use `utils.map('n', '<leader>x', function() ... end, 'Description')` in `keymaps.lua`
- Autocommand: Use `vim.api.nvim_create_autocmd` in `autocmds.lua` for event-driven behaviors

---

## Agent Operating Protocol

- **Strict Adherence:** Only change what you are explicitly told to change.
- **Verify and Clarify:** If you believe there is an error in my request, you must point it out and wait for my explicit permission before making any changes or corrections. Your primary directive is to follow my instructions precisely.