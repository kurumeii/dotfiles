# Code Style and Conventions

## Lua Code Style (Neovim Configuration)

### Formatting Rules (stylua.toml)
- **Indentation**: Tabs (width: 2 spaces)
- **Line Length**: 120 characters
- **Quote Style**: Auto-prefer double quotes

### Coding Conventions
- Use `vim.o` for setting options (not `vim.opt`)
- Global configuration stored in `vim.g` tables (e.g., `vim.g.mini`)
- Plugin loading pattern: `now()` for immediate load, `later()` for deferred loading
- Modular structure: separate files for different concerns
- Minimal dependencies: prefer mini.nvim ecosystem when possible

### Variable Naming
- `snake_case` for variables and functions
- Descriptive names (e.g., `path_package`, `mini_path`)
- Global config tables use simple names (e.g., `vim.g.mini`)

### Code Organization
- Entry point (`init.lua`) handles bootstrapping and module loading
- Configuration split into logical modules under `lua/config/`
- Plugin configs isolated in separate files under `lua/plugins/`
- After-load customizations in `after/` directory

## Shell Script Style

### Bash/Zsh
- Use standard POSIX patterns
- Export environment variables explicitly
- Source completions for installed tools
- Use modern alternatives (eza, bat, rg) via aliases

## Git Configuration
- User: andrew nguyen <ngphuchoanganh@gmail.com>
- Merge tool: nvim
- Pager: diff-so-fancy
- GitHub CLI for credential management

## Template Files
- Use chezmoi template syntax: `{{ (keepassxc "path/to/secret").Password }}`
- Keep secrets in KeePassXC, never commit plain text secrets
- Template files end with `.tmpl` extension
