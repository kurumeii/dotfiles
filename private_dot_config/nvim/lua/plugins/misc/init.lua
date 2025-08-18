mininvim.deps.setup({
  {
    source = 'max397574/better-escape.nvim',
    later = true,
    name = 'better_escape',
    cb = function()
      require('plugins.misc.better_escape')
    end,
  },
  {
    source = 'windwp/nvim-ts-autotag',
    later = true,
    opts = {},
  },
  {
    source = 'MagicDuck/grug-far.nvim',
    later = true,
    cb = function()
      require('plugins.misc.grug-far')
    end,
  },
  {
    source = 'dstein64/vim-startuptime',
    cb = function()
      vim.keymap.set('n', '<leader>ps', '<cmd>StartupTime<cr>', { desc = 'StartupTime' })
    end,
  },
  {
    source = 'MeanderingProgrammer/render-markdown.nvim',
    later = true,
    cb = function()
      require('plugins.misc.render-markdown')
    end,
  },
  {
    source = 'stuckinsnow/import-size.nvim',
    later = true,
    cb = function()
      require('plugins.misc.import-size')
    end,
  },
})
