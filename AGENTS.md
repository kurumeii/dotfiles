# Agent Guidelines for Dotfiles (Chezmoi)

This repository manages personal dotfiles using **chezmoi**. It primarily contains shell scripts (Zsh/Bash) and Neovim configurations (Lua).

## 🛠 Build/Lint/Test Commands

### Chezmoi (General)
- **Check status**: `chezmoi status`
- **View diff**: `chezmoi diff`
- **Apply changes**: `chezmoi apply`
- **Add file**: `chezmoi add <file_path>`

### Lua (Neovim Config)
Navigate to `private_dot_config/nvim/` or `private_dot_config/minimax/` to run these:
- **Format code**: `stylua .` (Uses `stylua.toml`)
- **Spell check**: `cspell .` (Uses `cspell.config.yaml`)
- **Linting**: Lua Language Server (sumneko_lua) is used via Neovim. Check for diagnostics in-editor.
- **Verification**: Run `:checkhealth` inside Neovim to verify plugin and system status.

### Shell Scripts
- **Validation**: Use `shellcheck` for any `.sh` or `.bash` files if available.
- **Bootstrap**: `run_once_after_bootstrap.sh.tmpl` handles system setup. Run `chezmoi apply` to trigger it if changed.

---

## 🎨 Code Style Guidelines

### General Formatting
- **Indentation**: **Tabs** with a width of **2**.
- **Line Length**: Maximum **120 characters**.
- **Quotes**: Prefer **double quotes** (`"`) for strings.
- **Newlines**: Ensure files end with a single newline.

### Naming Conventions
- **Files**: lowercase with hyphens (e.g., `key-maps.lua`, `git-config.tmpl`).
- **Functions**: `camelCase` (e.g., `calculateTotal`).
- **Variables**: `snake_case` for local variables, `camelCase` for globals or module-level variables.
- **Constants**: `UPPER_CASE` with underscores.

### Lua Specifics
- **Types**: Use EmmyLua style annotations (`---@type`, `---@param`, `---@return`).
- **Modules**: Follow the `local M = {} ... return M` or `local H = {}` (helper) pattern.
- **Globals**: Avoid polluting the global namespace. Use `vim.g` for Neovim globals.
- **Error Handling**: Use `pcall` or `xpcall` when calling functions that might fail (e.g., requiring a plugin).

### Shell Specifics
- **Safety**: Always include `set -e` at the top of scripts to exit on error.
- **Templates**: Respect chezmoi template syntax `{{ ... }}`.

---

## 🤖 Agent Operating Protocol (Serena & Beyond)

1. **Information Retrieval**:
   - **ALWAYS** use `context7_query-docs` and `tavily_search` before answering complex technical questions.
   - Verify the latest documentation for tools like `chezmoi`, `lazy.nvim`, or `stylua`.
2. **Path Management**:
   - **ALWAYS** use absolute paths for file operations. Resolve relative paths against the project root: `/home/hoanh_techvify/.local/share/chezmoi`.
3. **Double-Check**:
   - Review your proposed code changes against existing patterns in the repo.
   - Verify that your bash commands are safe (non-destructive unless requested).
4. **Serena Integration**:
   - Activate the Serena tool at the start of any task.
   - Follow the `onboarding` process if not already completed.
5. **Formatting**:
   - Adhere strictly to the `stylua.toml` settings when editing Lua files.

---

## 🏗 Architecture Overview

- **`private_dot_config/`**: Contains application configurations (Neovim, Ghostty, Wezterm, etc.).
- **`private_dot_config/nvim/`**: Primary Neovim configuration (modular).
- **`private_dot_config/minimax/`**: Alternative/Experimental Neovim config.
- **`dot_zshrc.tmpl`**: Zsh configuration template.
- **`Brewfile`**: System dependencies managed via Homebrew.
- **`run_once_after_bootstrap.sh.tmpl`**: Linux-specific initialization script.
