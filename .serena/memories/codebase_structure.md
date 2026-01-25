# Codebase Structure

## Root Directory
```
/home/andrew/.local/share/chezmoi/
├── dot_bashrc                  # Bash shell configuration
├── dot_zshrc                   # Zsh shell configuration
├── dot_bash_profile            # Bash profile
├── dot_zshenv.tmpl             # Environment variables template (with secrets)
├── dot_gitconfig               # Git configuration
├── andrew.omp.json             # Oh My Posh prompt theme
├── .chezmoiignore              # Chezmoi ignore patterns
├── README.md                   # Project documentation (currently empty)
├── bin/                        # Executable scripts
│   └── executable_start_serena
├── dot_config/                 # XDG config directory
│   ├── nvim/                   # Neovim configuration (main Lua codebase)
│   ├── btop/                   # System monitor config
│   ├── fuzzel/                 # Application launcher
│   ├── lazygit/                # Git TUI config
│   ├── keepassxc/              # Password manager config
│   ├── wezterm/                # Terminal emulator (Lua config)
│   ├── waybar/                 # Status bar (JSON/CSS)
│   ├── danksearch/             # Search tool config
│   ├── mako/                   # Notification daemon
│   ├── mise/                   # Development tool version manager
│   ├── niri/                   # Window compositor (KDL config + scripts)
│   ├── opencode/               # OpenCode AI assistant config
│   ├── rclone/                 # Cloud storage sync
│   └── yazi/                   # Terminal file manager
└── Gdrive/                     # Google Drive sync location
```

## Neovim Structure (Primary Lua Codebase)
```
dot_config/nvim/
├── init.lua                           # Entry point, sets up mini.deps
├── stylua.toml                        # Lua formatter configuration
├── lua/
│   ├── config/
│   │   ├── options.lua               # Vim options and settings
│   │   ├── keymaps.lua               # Key mappings
│   │   ├── autocmds.lua              # Autocommands
│   │   ├── mininvim.lua              # Mini.nvim configuration
│   │   ├── utils.lua                 # Utility functions
│   │   └── lint/                     # Linter configurations
│   │       ├── biome.lua
│   │       └── cspell.lua
│   └── plugins/                       # Plugin configurations
│       ├── mini/*.lua                 # Mini.nvim module configs
│       ├── lspconfig.lua             # LSP setup
│       ├── treesitter.lua            # Syntax highlighting
│       ├── conform.lua               # Code formatting
│       ├── nvim-lint.lua             # Linting
│       ├── blink.lua                 # Completion
│       └── ... (other plugins)
└── after/
    ├── lsp/                          # LSP server configurations
    ├── queries/toml/                 # Treesitter queries
    └── snippets/                     # Code snippets
```

## File Naming Convention
Chezmoi uses special prefixes to indicate how files should be processed:
- `dot_` → `.` (hidden files, e.g., `dot_bashrc` → `.bashrc`)
- `executable_` → Makes file executable
- `.tmpl` → Template file processed by chezmoi (e.g., `dot_zshenv.tmpl`)
- `private_` → Files with restricted permissions
