# Copilot Instructions for miniVim

This document provides instructions for AI coding agents to effectively contribute to this Neovim configuration.

## Architecture Overview

This configuration is a modular Neovim setup built upon the `mini.nvim` library. The main goal is to create a minimal, fast, and stable user experience.

- **Entry Point**: The configuration is loaded from `init.lua`.
- **Core Logic**: The heart of the configuration is a custom plugin loader located at `lua/config/mini.lua`. This module wraps `mini.deps` (the dependency manager from `mini.nvim`) to load both external plugins from Git and local configuration modules.
- **Modularity**: The configuration is heavily modular. All plugins and features are organized into subdirectories within `lua/plugins/`. The main categories are `core`, `mini`, `snacks`, `theme`, `autocomplete`, `misc`, and `ui`. Each of these directories contains an `init.lua` that returns a list of plugin specifications to be loaded.

## Key Files and Directories

- `init.lua`: The main entry point. It initiates the loading of all other modules.
- `lua/config/mini.lua`: The custom plugin loader. **Understanding this file is crucial** for managing dependencies. It handles the asynchronous loading of plugins.
- `lua/plugins/`: This is where all plugin setups are located. To add, remove, or configure a plugin, you will be editing files within this directory.
- `lua/plugins/core/init.lua`: Defines core, essential plugins like `mason.nvim` (for managing LSPs, formatters, linters), `conform.nvim` (formatting), and `lint.nvim` (linting).
- `lua/plugins/mini/init.lua`: Configures the various modules provided by `mini.nvim` itself.
- `lsp/`: Contains configurations for specific Language Server Protocol (LSP) servers (e.g., `vtsls.lua`, `prismals.lua`). These are typically attached to clients via `nvim-lspconfig`.
- `types/init.lua` is the main custom typing for better intellisense, very *recommended* to use and create new one

## Developer Workflows

### Adding a New Plugin

1.  Identify the correct category for the plugin under `lua/plugins/`. For example, a UI plugin would go into `lua/plugins/ui/init.lua`.
2.  Add a new table entry to the list returned by the `init.lua` file.
3.  The spec table should have a `source` key pointing to the GitHub repository (e.g., `'owner/repo'`).
    - Optionally, `source` can point to a local module inside `plugin` directory as well
4.  To configure the plugin, you can provide an `opts` table which will be passed to the plugin's `setup()` function, or a `cb` (callback) function for more complex setup logic. The order goes like this: `cb` will take priority over `opts`, however if you want to add with `opts`, you must provide a `name` key, which will help the plugin loader actually load the plugin

**Example: Adding a new plugin to `lua/plugins/misc/init.lua`**

```lua
-- In lua/plugins/misc/init.lua
return {
  -- ... other plugins
  {
    source = 'user/new-plugin.(nvim | vim | lua)',
    name = 'new-plugin',
    later = true -- or false
    opts = {
      setting1 = true,
      setting2 = 'value',
    },
  },
}

-- OR

return {
  {
    source = 'user/new-plugin',
    cb = function()
      -- You call the setup here
    end
  }
}
```

### Configuring an Existing Plugin

1.  Locate the plugin's definition within the `lua/plugins/` directory tree.
2.  Modify the `opts` table or the `cb` function associated with the plugin's spec.

### Managing LSPs, Formatters, and Linters

- **Installation**: Tools are managed by `mason.nvim` and `mason-tool-installer` configured in `lua/plugins/core/mason.lua`. To add a new tool, add it to the `ensure_installed` list.
- **LSP Configuration**: LSP-specific settings are defined in the `lsp/` directory. These files are loaded by the `mason-lspconfig` setup. By default mason will handle the default setup for the plugin, most of the time we don't need to override this
- **Formatting**: Code formatting is handled by `conform.nvim` (`lua/plugins/core/conform.lua`). You can define formatters for specific file types here. 
- **Linting**: Linting is handled by `lint.nvim` (`lua/plugins/core/lint.lua`).

## Project-Specific Conventions

- **Plugin Loader**: **Always** use the custom loader in `lua/config/mini.lua` by adding specs to the `lua/plugins` files. Do not call `MiniDeps.add()` or `require()` directly for plugins in the main configuration files.
- **Local Modules**: Local configuration files (like `keymap.lua`, `option.lua`) are also loaded via the same system but have a `source` that is a local module name (e.g., `{ source = 'keymap' }`).
- **Global State**: A global table `_G.mininvim` is used to store shared configuration data like icons and colors. Ensure that the table can be accessed anywhere with intellisense. Opt to this if you can, otherwise setting `vim.g.` will work as well but ensure it's local and served an exact purpose.
