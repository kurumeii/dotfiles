# Copilot Instructions for nvim

## Project Overview

This is a modular Neovim configuration using Lua, structured for maintainability and extensibility. The main entry point is `init.lua`, which bootstraps the plugin manager (`lazy.nvim`) and loads configuration from the `lua/config` and `lua/plugins` directories.

## Architecture & Key Files

- `init.lua`: Bootstraps plugin manager, loads config, sets colorscheme.
- `lua/config/`: Core editor settings split into:
  - `options.lua`: Vim options and globals (e.g., leader keys, font settings).
  - `keymaps.lua`: Key mappings, often using utility functions from `utils.lua`.
  - `autocmds.lua`: Autocommands for file explorer, LSP, and buffer events.
  - `mininvim.lua`: Global icons and filetype/directory glyphs for UI enhancements.
- `lua/plugins/`: Each file configures a specific plugin (e.g., LSP, Treesitter, commenting, linting).
- `health.lua`: Health checks for Neovim version and required executables (`git`, `make`, `unzip`, `rg`).
- `utils.lua`: Shared utility functions for mapping keys, notifications, and more.

## Developer Workflows

- **Plugin Management:** Uses [lazy.nvim](https://github.com/folke/lazy.nvim). Plugins are defined in `lua/plugins/` and loaded via `init.lua`.
- **Configuration Reload:** Changes to files in `lua/config/` or `lua/plugins/` require restarting Neovim or re-sourcing the file.
- **Health Check:** Run `:checkhealth` to verify system and plugin requirements.
- **Keymaps:** Custom keymaps are defined in `keymaps.lua` and use utility wrappers for consistency.
- **Autocommands:** Custom autocommands are set in `autocmds.lua`, including LSP attach events and file explorer behaviors.

## Project-Specific Patterns

- **Modular Config:** Each plugin and config aspect is isolated in its own file for clarity and easy extension.
- **Global Icons:** UI glyphs and icons are defined in `mininvim.lua` for consistent visual language across plugins.
- **Utility-Driven Mapping:** Keymaps and autocommands use functions from `utils.lua` to reduce duplication and enforce conventions.
- **LSP & Diagnostics:** LSP-related keymaps and autocommands are grouped and use buffer-local mappings.
- **Health Checks:** `health.lua` provides a template for system validation, not required for config but useful for onboarding.

## Integration Points & External Dependencies

- **Plugin Manager:** `lazy.nvim` (auto-cloned if missing).
- **Required Tools:** `git`, `make`, `unzip`, `rg` (ripgrep) for plugin installation and searching.
- **Nerd Font:** Set `vim.g.have_nerd_font = true` if using a Nerd Font for icon support.

## Example Patterns

- **Adding a Plugin:** Create a new file in `lua/plugins/` and add its config. Reference it in `init.lua` via the lazy setup import.
- **Custom Keymap:** Use `utils.map('n', '<leader>x', function() ... end, 'Description')` in `keymaps.lua`.
- **Autocommand:** Use `vim.api.nvim_create_autocmd` in `autocmds.lua` for event-driven behaviors.

## References

- Main entry: `init.lua`
- Config: `lua/config/`
- Plugins: `lua/plugins/`
- Utilities: `lua/utils.lua`
- Health: `lua/health.lua`

---

_If any section is unclear or missing important project-specific details, please provide feedback to improve these instructions._
