mininvim.deps.setup({
  {
    source = 'neovim/nvim-lspconfig',
    later = true,
    depends = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- mason easy installer
      'jay-babu/mason-nvim-dap.nvim', -- mason dap
    },
    cb = function()
      require('plugins.core.mason')
    end,
  },

  {
    source = 'stevearc/conform.nvim',
    later = true,
    cb = function()
      require('plugins.core.conform')
    end,
  },
  {
    source = 'folke/lazydev.nvim',
    depends = {
      'justinsgithub/wezterm-types',
      'b0o/SchemaStore.nvim',
    },
    name = 'lazydev',
    later = true,
    opts = {
      integrations = {
        lspconfig = true,
      },
      library = {
        'nvim-dap-ui',
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'wezterm-types', mods = { 'wezterm' } },
      },
    },
  },
  {
    source = 'TheLeoP/powershell.nvim',
    later = true,
    disable = true,
    name = 'powershell',
    opts = {
      bundle_path = vim.fn.stdpath('data') .. '/mason/packages/powershell-editor-services',
    },
  },
  {
    source = 'mfussenegger/nvim-lint',
    later = true,
    cb = function()
      require('plugins.core.lint')
    end,
  },
  {
    source = 'mfussenegger/nvim-dap',
    later = true,
    depends = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'jbyuki/one-small-step-for-vimkind',
      'nvim-neotest/nvim-nio',
      'jay-babu/mason-nvim-dap.nvim', -- mason dap
      'nvim-lua/plenary.nvim',
    },
    cb = function()
      require('plugins.core.dap')
    end,
  },
  {
    source = 'lewis6991/gitsigns.nvim',
    later = true,
    cb = function()
      require('plugins.core.gitsigns')
    end,
  },
})
