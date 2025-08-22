This is a Neovim configuration based on [LazyVim](https://www.lazyvim.org/). It uses `lazy.nvim` for plugin management. The main configuration file is `init.lua`, which bootstraps `lazy.nvim` and loads the configuration from `lua/config/lazy.lua`.

The configuration is structured as follows:

- `init.lua`: The entry point of the Neovim configuration.
- `lua/config/lazy.lua`: The core `lazy.nvim` setup, which specifies the plugins to load.
- `lua/plugins/`: This directory contains the plugin specifications.
  - `core.lua`: Contains core plugins.
  - `themes.lua`: Sets the colorscheme to `gruvbox`.
  - `example.lua`: Is your example file that is **ONLY** for reference on how to add a new plugin. You cannot add or edit anything in this file

## Development Conventions

The configuration is written in Lua. The code is formatted with `stylua`. The configuration is structured to be modular, with each plugin's configuration in its own file in the `lua/plugins/` directory. You should **always** follow the style in `stylua.toml`.

When i say disable a plugin, it means you need to scan the lazy-lock.json file to see if the plugin is there first. If it is, go to `~/.local/share/nvim/lazy/LazyVim/` directory to scan the code there, WHICH you can know what to do with my request. **REMEMBER** _DO NOT_ change code inside that directory, instead, you override it inside `lua/plugins/` with exact same name of the plugin
