require('config.mini').setup({
  {
    source = 'catppuccin/nvim',
    name = 'catppuccin',
    cb = function()
      require('plugins.theme.catppuccin')
    end,
  },
  {
    source = 'folke/tokyonight.nvim',
    cb = function()
      require('plugins.theme.tokyonight')
    end,
  },
  {
    source = 'rebelot/kanagawa.nvim',
    cb = function()
      require('plugins.theme.kanagawa')
    end,
  },
  {
    source = 'AstroNvim/astrotheme',
    cb = function()
      require('plugins.theme.astro')
    end,
  },
  {
    source = 'ellisonleao/gruvbox.nvim',
    name = 'gruvbox',
    opts = {
      ---@module 'gruvbox'
      ---@type GruvboxConfig
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
        transparent_mode = true,
      },
    },
  },
})

vim.cmd.colorscheme('gruvbox')
