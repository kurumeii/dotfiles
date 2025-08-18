---@diagnostic disable: missing-fields
mininvim.deps.setup({
  {
    source = 'folke/snacks.nvim',
    name = 'snacks',
    later = true,
    ---@module 'snacks'
    ---@type Snacks
    opts = {
      lazygit = {
        enabled = true,
      },
      statuscolumn = {
        left = { 'mark', 'sign' }, -- priority of signs on the left (high to low)
        right = { 'fold', 'git' }, -- priority of signs on the right (high to low)
        refresh = 50, -- refresh at most every 50ms
        folds = {
          open = true,
          git_hl = true,
        },
        enabled = true,
      },
      bigfile = { enabled = true },
      scope = {
        enabled = true,
      },
      indent = {
        enabled = true,
      },
      terminal = { enabled = true },
      notifier = {
        enabled = true,
      },
      image = {
        enabled = true,
        force = true,
      },
    },
  },
})

require('plugins.snacks.keymap')
