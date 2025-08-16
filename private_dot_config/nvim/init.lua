_G.mininvim = {
  icons = require('config.icons'),
  tw_colors = require('config.tailwind-color'),
  word_colors = require('config.color-word'),
  deps = require('config.mini'),
}

mininvim.deps.setup({
  { source = 'config.option' },
  { source = 'config.keymap' },
  { source = 'plugins.mini.sessions' },
  { source = 'plugins.mini.notify', disable = false },
  { source = 'plugins.mini.starter', disable = false },
  { source = 'plugins.mini.icons' },
  { source = 'plugins.theme' },
  { source = 'plugins.mini.basics' },
  { source = 'mini.colors', later = true, opts = {} },
  { source = 'mini.keymap', later = true, opts = {} },
  { source = 'plugins.mini.animate', later = true },
  { source = 'plugins.mini.bracketed', later = true },
  { source = 'plugins.mini.surround', later = true },
  { source = 'plugins.mini.jump', later = true },
  { source = 'plugins.mini.pairs', later = true },
  { source = 'plugins.mini.cursorword', later = true },
  { source = 'mini.trailspace', later = true, opts = {} },
  { source = 'mini.fuzzy', later = true, opts = {} },
  { source = 'mini.extra', later = true, opts = {} },
  { source = 'mini.operators', later = true, opts = {} },
  { source = 'mini.move', later = true, opts = {} },
  { source = 'mini.bufremove', later = true, opts = {} },
  { source = 'plugins.mini.comment', later = true },
  { source = 'plugins.mini.misc', later = true },
  { source = 'plugins.mini.snippets', later = true },
  { source = 'plugins.mini.jump2d', later = true },
  { source = 'plugins.mini.tabline', later = true, disable = false },
  { source = 'plugins.mini.pick', later = true, disable = false },
  { source = 'plugins.mini.diff', later = true },
  { source = 'plugins.mini.git', later = true },
  { source = 'plugins.mini.ai', later = true },
  { source = 'plugins.mini.indentscope', later = true, disable = false },
  { source = 'plugins.mini.completion', later = true, disable = false },
  {
    source = 'saghen/blink.cmp',
    later = true,
    disable = true,
    hooks = {
      post_install = require('utils').build_blink,
      post_checkout = require('utils').build_blink,
    },
    cb = function()
      require('plugins.others.blink-cmp')
    end,
  },
  { source = 'plugins.mini.hipatterns', later = true },
  { source = 'plugins.mini.minimap', later = true },
  {
    source = 'plugins.mini.files',
    later = false,
    disable = false,
  },
  {
    source = 'plugins.mini.clues',
  },
  {
    source = 'plugins.mini.visited',
    later = true,
    disable = false,
  },
  {
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    later = true,
    hooks = {
      post_checkout = function()
        vim.cmd('TSUpdate')
      end,
    },
    depends = {
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter',
    },
    cb = function()
      require('plugins.others.treesitter')
    end,
  },
  {
    source = 'max397574/better-escape.nvim',
    later = true,
    name = 'better_escape',
    cb = function()
      require('plugins.others.better_escape')
    end,
  },
  {
    source = 'windwp/nvim-ts-autotag',
    later = true,
    opts = {},
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
    source = 'nvim-lua/plenary.nvim',
    later = true,
    cb = function() end,
  },
  {
    source = 'SmiteshP/nvim-navic',
    depends = {
      'neovim/nvim-lspconfig',
    },
    later = true,
    cb = function()
      require('nvim-navic').setup({
        highlight = true,
        depth_limit = 4,
      })
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
  },
  {
    source = 'nvim-lualine/lualine.nvim',
    depends = {
      'SmiteshP/nvim-navic',
    },
    disable = true,
    later = true,
    cb = function()
      require('plugins.others.lualine')
    end,
  },
  {
    source = 'plugins.mini.statusline',
    later = true,
    disable = false,
  },
  {
    source = 'folke/lazydev.nvim',
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
    source = 'neovim/nvim-lspconfig',
    later = true,
    depends = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- mason easy installer
      'justinsgithub/wezterm-types',
      'b0o/SchemaStore.nvim',
    },
    cb = function()
      require('plugins.others.mason')
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
    },
    cb = function()
      require('plugins.others.debugger')
    end,
  },
  {
    source = 'stevearc/conform.nvim',
    later = true,
    cb = function()
      require('plugins.others.conform')
    end,
  },
  {
    source = 'kevinhwang91/nvim-ufo',
    depends = {
      'kevinhwang91/promise-async',
    },
    later = true,
    cb = function()
      require('plugins.others.ufo')
    end,
  },
  {
    source = 'supermaven-inc/supermaven-nvim',
    later = true,
    cb = function()
      require('plugins.others.supermaven')
    end,
  },
  {
    source = 'mfussenegger/nvim-lint',
    later = true,
    cb = function()
      require('plugins.others.lint')
    end,
  },
  {
    source = 'MagicDuck/grug-far.nvim',
    later = true,
    cb = function()
      require('plugins.others.grug-far')
    end,
  },
  {
    source = 'folke/snacks.nvim',
    later = true,
    cb = function()
      require('plugins.snacks')
    end,
  },
  { source = 'config.ftypes', later = true },
  {
    source = 'dstein64/vim-startuptime',
    cb = function()
      vim.keymap.set('n', '<leader>ps', '<cmd>StartupTime<cr>', { desc = 'StartupTime' })
    end,
  },
  {
    source = 'lewis6991/gitsigns.nvim',
    later = true,
    cb = function()
      require('plugins.others.gitsigns')
    end,
  },
  {
    source = 'yetone/avante.nvim',
    name = 'avante',
    disable = false,
    later = true,
    version = 'main',
    depends = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
    hooks = {
      post_checkout = require('utils').build_avante,
      post_install = require('utils').build_avante,
    },
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = 'gemini',
    },
  },
  {
    source = 'HakonHarnes/img-clip.nvim',
    name = 'img-clip',
    later = true,
    disable = true,
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
        -- required for Windows users
        use_absolute_path = true,
      },
    },
  },
  {
    source = 'MeanderingProgrammer/render-markdown.nvim',
    later = true,
    cb = function()
      require('plugins.others.render-markdown')
    end,
  },
  {
    source = 'stuckinsnow/import-size.nvim',
    later = true,
    cb = function()
      require('plugins.others.import-size')
    end,
  },
})
