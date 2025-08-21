return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    opts = {
      flavour = 'mocha',
      transparent_background = false,
      auto_integrations = true,
    }
  },
  {
    'folke/tokyonight.nvim',
    lazy = true,
    opts = {
      style = 'storm',
      light_style = 'day',
      transparent = false,
      lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
      dim_inactive = true, -- dims inactive windows
    }
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = true,
    opts = {
      compile = true,
      transparent = false,
      dimInactive = true,
      theme = 'dragon',
    }
  },
  {
    'AstroNvim/astrotheme',
    lazy = true,
    opts = {
      background = {
        dark = 'astrodark',
        light = 'astrolight',
      },
      style = {
        transparent = false,
      },
    }
  },
  {
    'ellisonleao/gruvbox.nvim',
    name = 'gruvbox',
    priority = 1000,
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
}
