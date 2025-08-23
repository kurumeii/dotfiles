This is a Neovim configuration based on [LazyVim](https://www.lazyvim.org/). It uses `lazy.nvim` for plugin management. The main configuration file is `init.lua`, which bootstraps `lazy.nvim`

The configuration is structured as follows:

- `init.lua`: The entry point of the Neovim configuration.
- `lua/plugins/`: This directory contains the plugin specifications.
  - `themes.lua`: This is the place to install new schema and set it.
  - `example.lua`: Is your example file that is **ONLY** for reference on how to add a new plugin. You cannot add or edit anything in this file

## Development Conventions

The configuration is written in Lua. The code is formatted with `stylua`. The configuration is structured to be modular, with each plugin's configuration in its own file in the `lua/plugins/` directory. You should **always** follow the style in `stylua.toml`.

When i say disable a plugin, it means you need to scan the lazy-lock.json file to see if the plugin is there first. **REMEMBER** _DO NOT_ change code inside `lua/plugins/exmaple.lua`, instead, you override it inside `lua/plugins/` with exact same name of the plugin. For example, when i say install me `a.nvim` plugin, you need to `mkdir` file `a.lua` inside `lua/plugins/` and add the plugin there.
