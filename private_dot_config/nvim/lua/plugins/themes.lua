---@type LazySpec[]
return {
  -- add gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      dim_inactive = true,
    },
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    ---@module 'kanagawa'
    ---@type KanagawaConfig
    opts = {
      theme = "dragon",
      dimInactive = true,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = 'mocha',
      transparent_background = false,
      auto_integrations = true,
    }
  }
}
