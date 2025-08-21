return {
  {
    'max397574/better-escape.nvim',
    lazy = true,
    opts = {
      default_mappings = false, -- setting this to false removes all the default mappings
      mappings = {
        -- i for insert
        i = {
          j = {
            j = false,
            k = '<Esc>',
          },
        },
        t = {
          q = {
            k = '<C-\\><C-n>',
          },
        },
        v = {
          j = {},
        },
        -- s = {
        --   j = {
        --     k = '<Esc>',
        --   },
        -- },
      },
    }
  },
  {
    'windwp/nvim-ts-autotag',
    lazy = true,
    opts = {},
  },
  {
    'MagicDuck/grug-far.nvim',
    lazy = true,
    opts = {
      -- grug-far options
      headerMaxWidth = 80, -- Maximum width of the header
      transient = true,    -- Whether to keep the window open after selection
    },
    config = function(_, opts)
      local grug = require('grug-far')
      local utils = require('utils')
      grug.setup(opts)
      utils.map({ 'n', 'v' }, utils.L('fg'), function()
        local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
        grug.open({
          prefills = {
            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
          },
        })
      end, 'Find and grug')
    end,
  },
  -- {
  --    'dstein64/vim-startuptime',
  --   cb = function()
  --     vim.keymap.set('n', '<leader>ps', '<cmd>StartupTime<cr>', { desc = 'StartupTime' })
  --   end,
  -- },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    lazy = true,
    ft = {
      "markdown", "Avante"
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { 'markdown', 'Avante' },
    },
  },
  {
    'stuckinsnow/import-size.nvim',
    lazy = true,
    config = function()
      local import_size = require('import-size')
      import_size.setup()
      local utils = require('utils')
      utils.map('n', utils.L('uc'), import_size.toggle, 'Toggle Import Size')
    end,
  },
}
